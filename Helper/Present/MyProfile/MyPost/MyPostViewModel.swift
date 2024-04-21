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
        let posts: Driver<[PostResponse.FetchPost]>
    }
    
    func transform(input: Input) -> Output {
        
        let posts: BehaviorRelay<[PostResponse.FetchPost]> = BehaviorRelay(value: [])
        
        input.postID
            .flatMap { ids in // String 배열
                let requests = ids.map { id in // String 단일
                    NetworkManager.shared.callAPI(type: PostResponse.FetchPost.self, router: Router.post(.postID(id: id)))
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
//                        case .errorMessage(let message):
//                            print(message)
//                            return nil
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
