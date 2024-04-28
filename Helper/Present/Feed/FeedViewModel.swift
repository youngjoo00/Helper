//
//  FeedViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FeedViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let storageButtonTap: Observable<PostResponse.FetchPost>
    }
    
    struct Output {
        let storageSuccess: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let storageSuccess = PublishRelay<String>()
        
        // 게시물 저장
        input.storageButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { data in
                let state = data.storage.listCheckedUserID
                return NetworkManager.shared.callAPI(type: PostResponse.StorageStatus.self, router: Router.post(.storage(query: PostRequest.StorageStatus(storageStatus: !state), id: data.postID)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    EventManager.shared.storageTrigger.onNext(())
                    let message = data.storageStatus ? "게시글을 저장했어요" : "게시글 저장을 취소했어요"
                    storageSuccess.accept(message)
                case .fail(let fail):
                    print(fail.localizedDescription)
                    //errorAlertMessage.accept(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            storageSuccess: storageSuccess.asDriver(onErrorJustReturn: "알 수 없는 오류입니다")
        )
    }
}
