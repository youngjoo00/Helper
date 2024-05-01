//
//  PostViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FindViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    private var findViewMode: FindViewMode
    
    init(_ findViewMode: FindViewMode) {
        self.findViewMode = findViewMode
    }
    
    struct Input {
        let fetchPostsTrigger: Observable<Void>
        let reachedBottomTrigger: ControlEvent<Void>
        let refreshControlTrigger: ControlEvent<Void>
        let region: Observable<String>
        let category: ControlProperty<Int>
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
        
        let category = input.category
            .map { value in
                switch value {
                case 0:
                    return HelperString.categoryPerson
                case 1:
                    return HelperString.categoryAnimal
                case 2:
                    return HelperString.categoryThing
                default:
                    return HelperString.categoryPerson
                }
            }
        

        let requestModel = Observable.combineLatest(next, input.region, category)
            .withUnretained(self)
            .map { owner, data in
                let (next, region, category) = data
                let productID = "\(region)_\(category)"
                
                switch owner.findViewMode {
                case .finding:
                    return PostRequest.FetchHashTag(next: next, productID: productID, hashTag: HelperString.hashTagFinding)
                case .found:
                    return PostRequest.FetchHashTag(next: next, productID: productID, hashTag: HelperString.hashTagFound)
                }
            }
        
        let fetchPosts = input.fetchPostsTrigger
            .do(onNext: { _ in next.onNext("") })
            .debug("fetch")
        
        let reachedBottom = input.reachedBottomTrigger
            .withLatestFrom(next)
            .filter { $0 != "0" && $0 != "" } // next 값이 "", "0"이 아닌 경우에만 진행
            .do(onNext: { _ in isBottomLoading.accept(true) })
            .debounce(.seconds(1), scheduler: MainScheduler.instance) // 지금은 1초를 무조건 기다렸다가 방출함
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
            .withLatestFrom(requestModel)
            .flatMap { NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchHashTag(query: $0))) }
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
