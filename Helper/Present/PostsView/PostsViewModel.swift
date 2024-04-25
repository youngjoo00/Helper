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
    case finding
    case found
    case myPost
    case myStorage
}

final class PostsViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    var mode: PostsViewModelMode
    
    init(mode: PostsViewModelMode = PostsViewModelMode.finding) {
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
        
        // loadTrigger
        let loadDataTrigger = Observable.merge(
            input.fetchPostsTrigger.do(onNext: { _ in next.onNext("") }), // 옵저버블을 중간에 안바꾸고 이벤트를 넣을 수 있음,, 너무 좋다,,
            input.reachedBottomTrigger.asObservable().do(onNext: { _ in isBottomLoading.accept(true)}),
            input.refreshControlTrigger.asObservable().do(onNext: { _ in
                next.onNext("")
                isRefreshControlLoading.accept(true)
            }).debounce(.seconds(1), scheduler: MainScheduler.instance)
        )
        
        switch mode {
        case .finding:
            // fetch Post
            loadDataTrigger
                .withLatestFrom(next)
                .flatMap { next -> Observable<APIResult<PostResponse.Posts>> in
                    if next == "0" {
                        isRefreshControlLoading.accept(false)
                        isBottomLoading.accept(false)
                        return .empty()
                    } else {
                        // MARK: - 네트워크를 호출하는 여기만 다름 -> 그럼 네트워크 요청만 뷰컨에서 보내주면 되나?
                        return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.otherUserFetchPosts(next: next, userID: myID))).asObservable()
                    }
                }
                //.delay(.seconds(1), scheduler: MainScheduler.instance)
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
        case .found:
            // fetch Post
            loadDataTrigger
                .withLatestFrom(next)
                .flatMap { next -> Observable<APIResult<PostResponse.Posts>> in
                    if next == "0" {
                        isRefreshControlLoading.accept(false)
                        isBottomLoading.accept(false)
                        return .empty()
                    } else {
                        // MARK: - 네트워크를 호출하는 여기만 다름 -> 그럼 네트워크 요청만 뷰컨에서 보내주면 되나?
                        return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.otherUserFetchPosts(next: next, userID: myID))).asObservable()
                    }
                }
                //.delay(.seconds(1), scheduler: MainScheduler.instance)
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
        case .myPost:
            // fetch Post
            loadDataTrigger
                .withLatestFrom(next)
                .flatMap { next -> Observable<APIResult<PostResponse.Posts>> in
                    if next == "0" {
                        isRefreshControlLoading.accept(false)
                        isBottomLoading.accept(false)
                        return .empty()
                    } else {
                        // MARK: - 네트워크를 호출하는 여기만 다름 -> 그럼 네트워크 요청만 뷰컨에서 보내주면 되나?
                        return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.otherUserFetchPosts(next: next, userID: myID))).asObservable()
                    }
                }
                //.delay(.seconds(1), scheduler: MainScheduler.instance)
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
        case .myStorage:
            // fetch Post
            loadDataTrigger
                .withLatestFrom(next)
                .flatMap { next -> Observable<APIResult<PostResponse.Posts>> in
                    if next == "0" {
                        isRefreshControlLoading.accept(false)
                        isBottomLoading.accept(false)
                        return .empty()
                    } else {
                        return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchStorage(next: next))).asObservable()
                    }
                }
                //.delay(.seconds(1), scheduler: MainScheduler.instance)
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
        }
       
        
        
        return Output(posts: posts.asDriver(),
                      errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
                      isRefreshControlLoading: isRefreshControlLoading.asDriver(onErrorJustReturn: false),
                      isBottomLoading: isBottomLoading.asDriver(onErrorJustReturn: false)
        )
    }
}
