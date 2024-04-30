//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()

    struct Input {
        let viewWillAppearTrigger: ControlEvent<Void>
        let nickname: Observable<String>
        let nextButtonTap: ControlEvent<Void>
    }
}

// MARK: - SignUp
extension NicknameViewModel {
    
    struct Output {
        let viewWillAppearTrigger: Driver<Void>
        let isValid: Driver<Bool>
        let description: Driver<String>
        let nextButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let nextButtonTapTrigger = PublishRelay<Void>()
        
        let isValid = input.nickname
            .map { $0.count >= 2 }
        
        let description = isValid
            .map { $0 ? "" : "닉네임은 최소 두 글자 이상입니다" }
        
        input.nextButtonTap
            .withLatestFrom(input.nickname)
            .subscribe(with: self) { owner, nickname in
                UserProfileManager.shared.nick = nickname
                nextButtonTapTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            viewWillAppearTrigger: input.viewWillAppearTrigger.asDriver(),
            isValid: isValid.asDriver(onErrorJustReturn: false),
            description: description.asDriver(onErrorJustReturn: ""),
            nextButtonTapTrigger: nextButtonTapTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}

// MARK: - EditProfile
extension NicknameViewModel {
    
    struct EditOutput {
        let viewWillAppearTrigger: Driver<Void>
        let isValid: Driver<Bool>
        let description: Driver<String>
        let successTrigger: Driver<Void>
        let errorMessage: Driver<String>
    }
    
    func editTransform(input: Input) -> EditOutput {
        
        let successTrigger = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()
        
        let isValid = input.nickname
            .map { $0.count >= 2 }
        
        let description = isValid
            .map { $0 ? "" : "닉네임은 최소 두 글자 이상입니다" }
        
        input.nextButtonTap
            .withLatestFrom(input.nickname)
            .map { UserRequest.EditNickname(nick: $0) }
            .flatMap { NetworkManager.shared.EditProfileCallAPI(type: UserResponse.MyProfile.self, router: Router.user(.editProfile(query: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    EventManager.shared.myProfileInfo.onNext(data)
                    successTrigger.accept(())
                case .fail(let fail):
                    errorMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return EditOutput(
            viewWillAppearTrigger: input.viewWillAppearTrigger.asDriver(),
            isValid: isValid.asDriver(onErrorJustReturn: false),
            description: description.asDriver(onErrorJustReturn: ""),
            successTrigger: successTrigger.asDriver(onErrorDriveWith: .empty()),
            errorMessage: errorMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다")
        )
    }
}
