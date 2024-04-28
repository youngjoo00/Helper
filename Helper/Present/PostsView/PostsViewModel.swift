//
//  PostsViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/25/24.
//

import Foundation
import RxSwift
import RxCocoa

enum PostsViewModelMode {
    case findingAll
    case foundAll
    case myPost
    case myStorage
}

final class PostsViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    var mode: PostsViewModelMode
    
    init(mode: PostsViewModelMode = PostsViewModelMode.findingAll) {
        self.mode = mode
    }
    
    struct Input {
        let fetchPostsTrigger: Observable<Void>
        let reachedBottomTrigger: ControlEvent<Void>
        let refreshControlTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let posts: Driver<[PostResponse.FetchPost]>
        let errorAlertMessage: Driver<String>
        let isRefreshControlLoading: Driver<Bool>
        let isBottomLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
   
        let myID = UserDefaultsManager.shared.getUserID()
        let posts: BehaviorRelay<[PostResponse.FetchPost]> = BehaviorRelay(value: [])
        let next = BehaviorSubject(value: "")
        
        let errorAlertMessage = PublishRelay<String>()
        let isRefreshControlLoading = PublishRelay<Bool>()
        let isBottomLoading = PublishRelay<Bool>()
        
        // 1. fetch 이벤트는 바로 보여야함
        // 2. reachedBottom/refreshControl 은 네트워크 호출과 동시에 최소 1초 로딩
        // 3. fetch/refresh 는 next 값이 비어있게
        
        // loadTrigger
//        let loadDataTrigger = Observable.merge(
//            input.fetchPostsTrigger.do(onNext: { _ in next.onNext("") }), // 옵저버블을 중간에 안바꾸고 이벤트를 넣을 수 있음,, 너무 좋다,,
//            input.reachedBottomTrigger.asObservable().do(onNext: { _ in isBottomLoading.accept(true)}).debounce(.seconds(1), scheduler: MainScheduler.instance),
//            input.refreshControlTrigger.asObservable().do(onNext: { _ in
//                next.onNext("")
//                isRefreshControlLoading.accept(true)
//            }).debounce(.seconds(1), scheduler: MainScheduler.instance) // 딜레이를 여기서 넣어주면 네트워크 통신 자체가 1초 밀리게 되니 문제가 있음
//        )

        let loadDataTrigger = Observable.merge(
            input.fetchPostsTrigger.do(onNext: { _ in next.onNext("") }),
            input.reachedBottomTrigger.asObservable().do(onNext: { _ in isBottomLoading.accept(true)}),
            input.refreshControlTrigger.asObservable().do(onNext: { _ in
                next.onNext("")
                isRefreshControlLoading.accept(true)
            })
        )
        
        loadDataTrigger
            .withLatestFrom(next)
            .flatMap { [weak self] next -> Observable<APIResult<PostResponse.Posts>> in
                guard let self else { return .empty() }
                if next == "0" {
                    isRefreshControlLoading.accept(false)
                    isBottomLoading.accept(false)
                    return .empty()
                } else {
                    switch self.mode {
                    case .findingAll:
                        return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchHashTag(query: PostRequest.FetchHashTag(next: next, productID: "", hashTag: HelperString.hashTagFinding)))).asObservable()
                    case .foundAll:
                        return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchHashTag(query: PostRequest.FetchHashTag(next: next, productID: "", hashTag: HelperString.hashTagFound)))).asObservable()
                    case .myPost:
                        return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.otherUserFetchPosts(next: next, userID: myID))).asObservable()
                    case .myStorage:
                        return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.otherUserFetchPosts(next: next, userID: myID))).asObservable()
                    }
                }
            }
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, result in
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
                isRefreshControlLoading.accept(false)
                isBottomLoading.accept(false)
            }
            .disposed(by: disposeBag)
        
        return Output(posts: posts.asDriver(),
                      errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
                      isRefreshControlLoading: isRefreshControlLoading.asDriver(onErrorJustReturn: false),
                      isBottomLoading: isBottomLoading.asDriver(onErrorJustReturn: false)
        )
    }
}
