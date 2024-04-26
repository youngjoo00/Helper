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
        let nickname: Driver<String>
        let postsID: PublishSubject<[String]>
        let editProfileTap: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let profileInfo = PublishRelay<UserResponse.MyProfile>()
        let nickname = PublishRelay<String>()
        let postsID = PublishSubject<[String]>()
        
        // viewDidLoad - myProfile 통신
        input.viewDidLoadTrigger
            .flatMap { NetworkManager.shared.callAPI(type: UserResponse.MyProfile.self, router: Router.user(.myProfile)) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    handleProfileInfo(data)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)

        // 프로필 수정 시
        EventManager.shared.editProfileInfoSubject
            .compactMap { $0 }
            .subscribe(with: self) { owner, info in
                handleProfileInfo(info)
            }
            .disposed(by: disposeBag)
        
        // 프로필 버튼 클릭 시
        input.editProfileTap
            .withLatestFrom(profileInfo)
            .subscribe(with: self) { owner, info in
                EventManager.shared.editProfileInfoSubject.onNext(info)
            }
            .disposed(by: disposeBag)
        
        func handleProfileInfo(_ info: UserResponse.MyProfile) {
            profileInfo.accept(info)
            nickname.accept(info.nick)
        }
        
        return Output(nickname: nickname.asDriver(onErrorJustReturn: ""),
                      postsID: postsID,
                      editProfileTap: input.editProfileTap.asDriver()
        )
    }
}
