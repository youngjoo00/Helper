//
//  FoundViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FoundViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let fetchTrigger: PublishSubject<Void>
        let region: Observable<String>
        let category: ControlProperty<Int>
        let reachedBottomTrigger: ControlEvent<Void>
        let refreshControlTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let posts: Driver<[PostResponse.FetchPost]>
        let isLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let posts = BehaviorRelay<[PostResponse.FetchPost]>(value: [])
        let next = BehaviorSubject(value: "")
        let isLoading = PublishRelay<Bool>()
        
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
        
        // 네트워크 통신 트리거
        let loadDataTrigger = Observable.merge(
            Observable.merge(input.fetchTrigger, input.refreshControlTrigger.asObservable()).do(onNext: { _ in
                next.onNext("")
            }),
            input.reachedBottomTrigger.asObservable()
        )
        
        // 요청 모델
        let requestModel = Observable.combineLatest(next, input.region, category) { next, region, category in
            let productID = region == HelperString.regions[0] ? "" : "\(region)_\(category)"
            return PostRequest.FetchHashTag(next: next, productID: productID, hashTag: HelperString.hashTagFound)
        }
        
        // 네트워크 통신
        loadDataTrigger
            .withLatestFrom(requestModel)
            .flatMap { requestModel -> Observable<(String, APIResult<PostResponse.Posts>)> in
                isLoading.accept(true)
                if requestModel.next == "0" {
                    isLoading.accept(false)
                    return Observable.empty() // empty 는 Observable<Never> 타입으로 그냥 아무것도 반환안하고 바로 complete 로 넘어가서 반환값에 영향 X
                } else {
                    return Observable.zip(
                        Observable.just(requestModel.next),
                        NetworkManager.shared.callAPI(type: PostResponse.Posts.self,
                                                      router: Router.post(.fetchHashTag(query: requestModel)))
                        .asObservable())
                }
            }
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, result in
                let nextValue = result.0
                let result = result.1
                
                switch result {
                case .success(let data):
                    if nextValue == "" {
                        posts.accept(data.data)
                    } else {
                        var temp = posts.value
                        temp.append(contentsOf: data.data)
                        posts.accept(temp)
                    }
                    next.onNext(data.nextCursor)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
                isLoading.accept(false)
            }
            .disposed(by: disposeBag)
        
        return Output(posts: posts.asDriver(onErrorJustReturn: []),
                      isLoading: isLoading.asDriver(onErrorJustReturn: false))
    }
}
