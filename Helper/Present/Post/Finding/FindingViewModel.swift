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
        let viewDidLoadTrigger: Observable<Void>
        let selectedControlSegment: Observable<Int>
    }
    
    struct Output {
        let posts: Driver<[ResponseModel.PostID]>
    }
    
    func transform(input: Input) -> Output {
        
        let posts = PublishRelay<[ResponseModel.PostID]>()
        
        input.viewDidLoadTrigger
            .flatMap { NetworkManager.shared.callAPI(type: ResponseModel.Posts.self, router: Router.post(.posts(query: ""))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    posts.accept(data.data)
                case .fail(let fail):
                    print(fail)
                case .errorMessage(let message):
                    print(message)
                }
            }
            .disposed(by: disposeBag)
        return Output(posts: posts.asDriver(onErrorJustReturn: []))
    }
}
