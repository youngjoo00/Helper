//
//  MyProfileViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyProfileViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let editProfileTap: ControlEvent<Void>
    }
    
    struct Output {
        let profileInfo: Driver<UserResponse.MyProfile>
        let postsID: PublishSubject<[String]>
        let editProfileTap: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let profileInfo = PublishRelay<UserResponse.MyProfile>()
        let postsID = PublishSubject<[String]>()
        
        // viewDidLoad - myProfile 통신
        input.viewDidLoadTrigger
            .flatMap { NetworkManager.shared.callAPI(type: UserResponse.MyProfile.self, router: Router.user(.myProfile)) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    EventManager.shared.myProfileInfo.onNext(data)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)

        // 프로필 수정 시
        EventManager.shared.myProfileInfo
            .compactMap { $0 }
            .subscribe(with: self) { owner, data in
                profileInfo.accept(data)
            }
            .disposed(by: disposeBag)
        
        return Output(
            profileInfo: profileInfo.asDriver(onErrorDriveWith: .empty()),
            postsID: postsID,
            editProfileTap: input.editProfileTap.asDriver()
        )
    }
}
