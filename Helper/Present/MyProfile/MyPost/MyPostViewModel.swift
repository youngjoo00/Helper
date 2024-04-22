//
//  MyPostViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyPostViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let fetchPostsTrigger: Observable<Void>
        let reachedBottomTrigger: ControlEvent<Void>
        let refreshControlTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let posts: Driver<[PostResponse.FetchPost]>
        let errorAlertMessage: Driver<String>
        let isLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let myID = UserDefaultsManager.shared.getUserID()
        let posts: BehaviorRelay<[PostResponse.FetchPost]> = BehaviorRelay(value: [])
        let next = BehaviorSubject(value: "")
        let fetchTrigger = BehaviorSubject(value: ())
        
        let errorAlertMessage = PublishRelay<String>()
        let isLoading = PublishRelay<Bool>()
        
        // loadTrigger
        let loadDataTrigger = Observable.merge(
            input.fetchPostsTrigger,
            input.reachedBottomTrigger.asObservable(),
            input.refreshControlTrigger.asObservable().do(onNext: { _ in // 옵저버블을 중간에 안바꾸고 이벤트를 넣을 수 있음,, 너무 좋다,,
                next.onNext("")
            })
        )
        
        // fetch Post
        loadDataTrigger
            .withLatestFrom(next)
            .flatMap { next -> Observable<APIResult<PostResponse.Posts>> in
                isLoading.accept(true)
                if next == "0" {
                    return .empty()
                } else {
                    return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.otherUserFetchPosts(next: next, userID: myID))).asObservable()
                }
            }
            .subscribe(with: self) { owner, result in
                print("실행합니다")
                switch result {
                case .success(let data):
                    do {
                        let currentNext = try next.value()
                        if currentNext == "" {
                            posts.accept(data.data)
                        } else {
                            var temp = posts.value
                            temp.append(contentsOf: data.data)
                            posts.accept(temp)
                        }
                        next.onNext(data.nextCursor)
                    } catch {
                        print(error)
                        errorAlertMessage.accept("다음 페이지 로딩 중 오류가 발생했습니다.")
                    }
                case .fail(let fail):
                    errorAlertMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
                isLoading.accept(false)
            }
            .disposed(by: disposeBag)
        
        
        return Output(posts: posts.asDriver(),
                      errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."), 
                      isLoading: isLoading.asDriver(onErrorJustReturn: false)
        )
    }
}

// 네트워크 모아서 써야할떄 씁시다
//input.postID
//    .flatMap { ids in // String 배열
//        let requests = ids.map { id in // String 단일
//            NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.postID(id: id)))
//                .asObservable() // Single<APIResult<T>> -> Observable<APIResult<ResponseModel.PostID>>
//        }
//        // 통신 결과를 zip 으로 묶기 위해 위에서 asObservable 메서드 사용
//        return Observable.zip(requests) { results in
//            // 성공한 케이스만 묶어서 반환
//            results.compactMap { result in
//                switch result {
//                case .success(let postID):
//                    return postID
//                case .fail(let fail):
//                    print(fail)
//                    return nil
////                        case .errorMessage(let message):
////                            print(message)
////                            return nil
//                }
//            }
//        }
//    }
//    .subscribe(with: self) { owner, result in
//        // 모든 요청의 결과를 받아 posts 에 방출
//        posts.accept(result)
//        print(result[0].files)
//    }
//    .disposed(by: disposeBag)
