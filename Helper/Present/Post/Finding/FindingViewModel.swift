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
        let fetchTrigger: Observable<Void>
        let region: Observable<String>
        let category: ControlProperty<Int>
    }
    
    struct Output {
        let posts: Driver<[PostResponse.FetchPost]>
    }
    
    func transform(input: Input) -> Output {
        
        let posts = PublishRelay<[PostResponse.FetchPost]>()
        
        let category = input.category
            .map { value in
                switch value {
                case 0:
                    return "사람"
                case 1:
                    return "동물"
                case 2:
                    return "물품"
                default:
                    return "사람"
                }
            }
        
        Observable.combineLatest(input.fetchTrigger, input.region, category)
            .debug("트리거 터졌나요")
            .map { _, region, category in
                return "\(region)_\(category)"
            }
            .flatMap { NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.posts(next: "", productID: $0, hashTag: "찾고있어요"))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    posts.accept(data.data)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(posts: posts.asDriver(onErrorJustReturn: []))
    }
}
