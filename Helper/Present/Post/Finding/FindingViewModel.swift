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
    }
    
    struct Output {
        let posts: Driver<[PostResponse.FetchPost]>
    }
    
    func transform(input: Input) -> Output {
        
        let posts = PublishRelay<[PostResponse.FetchPost]>()
        var nextCursor = BehaviorSubject(value: "")
        
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
        
        // 지역이 전체라면 해시태그로만 통신함
        let hashTagCategoryRequest = PublishSubject<PostRequest.FetchHashTag>()
        let hashTagRequest = PublishSubject<PostRequest.FetchHashTag>()
        
        // 마지막에 이벤트가 오면 -> nextCursor 를 갖고 호출을 해서 이어 붙임
        // 근데 마지막에 오는건 0 이고, 0으로 콜하면 마지막입니다 토스트 보낼거임
        // 값이 변경되면 빈 스트링을 갖는거고
        // 자 그러면 넥스트 커서를
        Observable.combineLatest(input.region.distinctUntilChanged(), category)
            .subscribe(with: self) { owner, _ in
                nextCursor.onNext("")
                input.fetchTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        
        input.fetchTrigger
            .withLatestFrom(Observable.combineLatest(nextCursor, input.region, category))
            .subscribe(with: self) { owner, value in
                let (nextCursor, region, category) = value
                if region == "전체" {
                    let requestModel = PostRequest.FetchHashTag(next: nextCursor, productID: "", hashTag: HelperString.hashTagFinding)
                    hashTagRequest.onNext(requestModel)
                } else {
                    let productID = "\(region)_\(category)"
                    let requestModel = PostRequest.FetchHashTag(next: nextCursor, productID: productID, hashTag: HelperString.hashTagFinding)
                    hashTagCategoryRequest.onNext(requestModel)
                }
            }
            .disposed(by: disposeBag)
        
//        input.reachedBottomTrigger
//            .withLatestFrom()
        
        // 해시태그랑 카테고리
        hashTagCategoryRequest
            .flatMap { NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchHashTag(query: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    posts.accept(data.data)
                    nextCursor.onNext(data.nextCursor)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 해시태그만
        hashTagRequest
            .flatMap { NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchHashTag(query: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    posts.accept(data.data)
                    nextCursor.onNext(data.nextCursor)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(posts: posts.asDriver(onErrorJustReturn: []))
    }
}
