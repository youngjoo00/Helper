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
        let postID: BehaviorSubject<[String]>
    }
    
    struct Output {
        let posts: Driver<[PostResponse.PostID]>
    }
    
    func transform(input: Input) -> Output {
        
        let posts: BehaviorRelay<[PostResponse.PostID]> = BehaviorRelay(value: [])
        
        input.postID
            .flatMap { ids in // String 배열
                let requests = ids.map { id in // String 단일
                    NetworkManager.shared.callAPI(type: PostResponse.PostID.self, router: Router.post(.postID(id: id)))
                        .asObservable() // Single<APIResult<T>> -> Observable<APIResult<ResponseModel.PostID>>
                }
                // 통신 결과를 zip 으로 묶기 위해 위에서 asObservable 메서드 사용
                return Observable.zip(requests) { results in
                    // 성공한 케이스만 묶어서 반환
                    results.compactMap { result in
                        switch result {
                        case .success(let postID):
                            return postID
                        case .fail(let fail):
                            print(fail)
                            return nil
                        case .errorMessage(let message):
                            print(message)
                            return nil
                        }
                    }
                }
            }
            .subscribe(with: self) { owner, result in
                // 모든 요청의 결과를 받아 posts 에 방출
                posts.accept(result)
                print(result[0].files)
            }
            .disposed(by: disposeBag)
        
        return Output(posts: posts.asDriver())
    }
}

// 전달받은 값 받아서 게시글 조회
//        input.postID
//            .debug("전달받았습니다 ==> ")
//            .subscribe(with: self, onNext: { owner, ids in
//                print(ids)
//                var tempPosts: [ResponseModel.PostID] = []
//                for id in ids {
//                    NetworkManager.shared.callAPI(type: ResponseModel.PostID.self, router: Router.post(.postID(id: id)))
//                        .subscribe(with: self) { owner, result in
//                            switch result {
//                            case .success(let data):
//                                tempPosts.append(data)
//                            case .fail(let fail):
//                                print(fail)
//                            case .errorMessage(let message):
//                                print(message)
//                            }
//                        }
//                        .disposed(by: owner.disposeBag)
//                }
//                posts.accept(tempPosts)
//            }, onError: { _, error in
//                print("에러에유: ", error)
//            }, onCompleted: { _ in
//                print("complete 유")
//            }, onDisposed: { _ in
//                print("dsipose유")
//            })
//            .disposed(by: disposeBag)

// 멘토님께 여쭤보기,,
//        fetchPost
//            .debug("fetchPost ==> ")
//            .flatMap { NetworkManager.shared.callAPI(type: ResponseModel.PostID.self, router: Router.post(.postID(id: $0))) }
//            .subscribe(with: self) { owner, result in
//                print("도대체 왜 여기가 실행이 안되는거에요,,")
//                switch result {
//                case .success(let data):
//                    print(data.title)
//                case .fail(let fail):
//                    print(fail)
//                case .errorMessage(let message):
//                    print(message)
//                }
//            } onCompleted: { _ in
//                print("fetchPost 완료")
//            } onDisposed: { _ in
//                print("fetchPost dispose")
//            }
//            .disposed(by: disposeBag)
