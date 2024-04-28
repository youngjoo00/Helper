//
//  OtherProfileViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class OtherProfileViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let userID: Observable<String>
    }
    
    struct Output {
        let profileInfo: Driver<UserResponse.OtherProfile>
        let postsID: PublishSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let profileInfo = PublishRelay<UserResponse.OtherProfile>()
        let postsID = PublishSubject<[String]>()
        
        // 다른 유저 프로필 조회
        input.userID
            .flatMap { NetworkManager.shared.callAPI(type: UserResponse.OtherProfile.self, router: Router.user(.otherProfile(userID: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print(data)
                    profileInfo.accept(data)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            profileInfo: profileInfo.asDriver(onErrorDriveWith: .empty()),
            postsID: postsID
        )
    }
}
