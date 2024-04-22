//
//  PostViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FindingViewModel: ViewModelType {
    
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
        
        // 1. 트리거를 통해 네트워크 통신을 진행함
        // 2. 담당할 트리거 -> fetchTrigger, reachedBottomTrigger, refreshControlTrigger
        
        // 3. 통신에 필요한 데이터 -> next, region, category
        // 4. region == 전체인 경우, region+category 는 비워버림

        // 5. 이제 진짜 콜 합시다
        
        let loadDataTrigger = Observable.merge(
            Observable.merge(input.fetchTrigger, input.refreshControlTrigger.asObservable()).do(onNext: { _ in
                next.onNext("")
            }),
            input.reachedBottomTrigger.asObservable()
        )
        
        let requestModel = Observable.combineLatest(next, input.region, category) { next, region, category in
            let productID = region == HelperString.regions[0] ? "" : "\(region)_\(category)"
            return PostRequest.FetchHashTag(next: next, productID: productID, hashTag: HelperString.hashTagFinding)
        }
        
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
            

//        
//        // 지역이 전체라면 해시태그로만 통신함
//        let hashTagCategoryRequest = PublishSubject<PostRequest.FetchHashTag>()
//        let hashTagRequest = PublishSubject<PostRequest.FetchHashTag>()
//        
//
//        Observable.combineLatest(input.region.distinctUntilChanged(), category)
//            .subscribe(with: self) { owner, _ in
//                next.onNext("")
//                input.fetchTrigger.onNext(())
//            }
//            .disposed(by: disposeBag)
//        
//        
//        input.fetchTrigger
//            .withLatestFrom(Observable.combineLatest(next, input.region, category))
//            .subscribe(with: self) { owner, value in
//                let (nextCursor, region, category) = value
//                if region == "전체" {
//                    let requestModel = PostRequest.FetchHashTag(next: nextCursor, productID: "", hashTag: HelperString.hashTagFinding)
//                    hashTagRequest.onNext(requestModel)
//                } else {
//                    let productID = "\(region)_\(category)"
//                    let requestModel = PostRequest.FetchHashTag(next: nextCursor, productID: productID, hashTag: HelperString.hashTagFinding)
//                    hashTagCategoryRequest.onNext(requestModel)
//                }
//            }
//            .disposed(by: disposeBag)
//        
////        input.reachedBottomTrigger
////            .withLatestFrom()
//        
//        // 해시태그랑 카테고리
//        hashTagCategoryRequest
//            .flatMap { NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchHashTag(query: $0))) }
//            .subscribe(with: self) { owner, result in
//                switch result {
//                case .success(let data):
//                    posts.accept(data.data)
//                    next.onNext(data.nextCursor)
//                case .fail(let fail):
//                    print(fail.localizedDescription)
//                }
//            }
//            .disposed(by: disposeBag)
//        
//        // 해시태그만
//        hashTagRequest
//            .flatMap { NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchHashTag(query: $0))) }
//            .subscribe(with: self) { owner, result in
//                switch result {
//                case .success(let data):
//                    posts.accept(data.data)
//                    next.onNext(data.nextCursor)
//                case .fail(let fail):
//                    print(fail.localizedDescription)
//                }
//            }
//            .disposed(by: disposeBag)
        
        return Output(posts: posts.asDriver(onErrorJustReturn: []), 
                      isLoading: isLoading.asDriver(onErrorJustReturn: false))
    }
}
