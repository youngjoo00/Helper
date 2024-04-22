//
//  MyStorageViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyStorageViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let fetchPostsTrigger: Observable<Void>
        let reachedBottomTrigger: ControlEvent<Void>
        let refreshControlTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let posts: Driver<[PostResponse.FetchPost]>
        let errorAlertMessage: Driver<String>
        let isLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let posts: BehaviorRelay<[PostResponse.FetchPost]> = BehaviorRelay(value: [])
        let next = BehaviorSubject(value: "")
        
        let errorAlertMessage = PublishRelay<String>()
        let isLoading = PublishRelay<Bool>()
        
        // loadTrigger
        let loadDataTrigger = Observable.merge(
            input.fetchPostsTrigger,
            input.reachedBottomTrigger.asObservable(),
            input.refreshControlTrigger.asObservable().do(onNext: { _ in
                next.onNext("")
            })
        )
        
        // fetch Post
        loadDataTrigger
            .withLatestFrom(next)
            .flatMap { next -> Observable<APIResult<PostResponse.Posts>> in
                isLoading.accept(true)
                if next == "0" {
                    isLoading.accept(false)
                    return .empty()
                } else {
                    return NetworkManager.shared.callAPI(type: PostResponse.Posts.self, router: Router.post(.fetchStorage(next: next))).asObservable()
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
                
                isLoading.accept(false)
            }
            .disposed(by: disposeBag)
        
        
        return Output(posts: posts.asDriver(),
                      errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."),
                      isLoading: isLoading.asDriver(onErrorJustReturn: false)
        )
    }
}
