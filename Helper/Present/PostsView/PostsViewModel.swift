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
    case myPosts
    case myStorage
    case feed
    case otherUserPosts(userID: String)
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
        // 2. reachedBottom/refreshControl 은 네트워크 호출과 동시에 최소 1초 로딩 -> 이거 어떻게 하는거지?
        // 3. fetch/refresh 는 next 값이 비어있게
        
        let fetchPosts = input.fetchPostsTrigger
            .do(onNext: { _ in next.onNext("") })
            .debug("fetch")
        
        let reachedBottom = input.reachedBottomTrigger
            .withLatestFrom(next)
            .filter { $0 != "0" && $0 != "" } // next 값이 "", "0"이 아닌 경우에만 진행
            .do(onNext: { _ in isBottomLoading.accept(true) })
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ in }
            .debug("reachedBottom")
        
        let refreshControl = input.refreshControlTrigger
            .do(onNext: { _ in
                next.onNext("")
                isRefreshControlLoading.accept(true) })
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ in }
        
        // loadTrigger
        let loadDataTrigger = Observable.merge(fetchPosts, reachedBottom, refreshControl)
        
        loadDataTrigger
            .debug("오는건가여?")
            .withLatestFrom(next)
            .flatMap { [weak self] next -> Observable<APIResult<PostResponse.Posts>> in
                guard let self else { return .empty() }
                switch self.mode {
                case .findingAll:
                    return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchHashTag(query: PostRequest.FetchHashTag(next: next, productID: "", hashTag: HelperString.hashTagFinding)))).asObservable()
                case .foundAll:
                    return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchHashTag(query: PostRequest.FetchHashTag(next: next, productID: "", hashTag: HelperString.hashTagFound)))).asObservable()
                case .myPosts:
                    return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.otherUserFetchPosts(next: next, userID: myID))).asObservable()
                case .myStorage:
                    return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchStorage(next: next))).asObservable()
                case .feed:
                    return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchFeed(query: PostRequest.FetchFeed(next: next, productID: HelperString.productID)))).asObservable()
                case .otherUserPosts(let userID):
                    return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.otherUserFetchPosts(next: next, userID: userID))).asObservable()
                }
            }
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
