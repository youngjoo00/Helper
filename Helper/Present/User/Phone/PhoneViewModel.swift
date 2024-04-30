//
//  PhoneViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()

    struct Input {
        let viewWillAppearTrigger: ControlEvent<Void>
        let phone: Observable<String>
        let nextButtonTap: ControlEvent<Void>
    }
}

// MARK: - SignUp
extension PhoneViewModel {
    
    struct Output {
        let viewWillAppearTrigger: Driver<Void>
        let isValid: Driver<Bool>
        let description: Driver<String>
        let nextButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let nextButtonTapTrigger = PublishRelay<Void>()
        
        let isValid: Observable<Bool> = input.phone
            .map { [weak self] phone in
                guard let self else { return false }
                return self.validatePhone(phone)
            }
        
        let description = isValid
            .map { $0 ? "" : "유효한 휴대폰 번호 형식이 아닙니다." }
        
        input.nextButtonTap
            .withLatestFrom(input.phone)
            .subscribe(with: self) { owner, phone in
                UserProfileManager.shared.phone = phone
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
extension PhoneViewModel {
    
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
        
        let isValid: Observable<Bool> = input.phone
            .map { [weak self] phone in
                guard let self else { return false }
                return self.validatePhone(phone)
            }
        
        let description = isValid
            .map { $0 ? "" : "유효한 휴대폰 번호 형식이 아닙니다." }
        
        input.nextButtonTap
            .withLatestFrom(input.phone)
            .map { UserRequest.EditPhone(phoneNum: $0) }
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
