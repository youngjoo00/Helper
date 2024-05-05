//
//  BirthdayViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()

    struct Input {
        let viewWillAppearTrigger: ControlEvent<Void>
        let year: Observable<String>
        let month: Observable<String>
        let day: Observable<String>
        let signUpButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let viewWillAppearTrigger: Driver<Void>
        let nextMonthField: Driver<Void>
        let nextDayField: Driver<Void>
        let isValid: Driver<Bool>
        let description: Driver<String>
        let signUpButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let signUpButtonTapTrigger = PublishRelay<Void>()

        // 자동으로 다음 텍스트 필드로 안내
        let nextMonthField = PublishRelay<Void>()
        let nextDayField = PublishRelay<Void>()
        
        input.year
            .filter { $0.count == 4 }
            .map { _ in }
            .take(1)
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: nextMonthField)
            .disposed(by: disposeBag)
        
        input.month
            .filter { $0.count == 2 }
            .map { _ in }
            .take(1)
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: nextDayField)
            .disposed(by: disposeBag)

        // 세개의 값이 다 들어온 경우 확인 시작
        let date = Observable.combineLatest(input.year, input.month, input.day)
        
        let isValid = date
            .map { year, month, day in
                guard year.count == 4, month.count == 2, day.count == 2 else { return false }
                guard let year = Int(year), let month = Int(month), let day = Int(day) else { return false }
                return DateManager.shared.validationDate(year: year, month: month, day: day)
            }
        
        let description = isValid
            .map { $0 ? "" : "유효한 생년월일이 아닙니다." }
        
        input.signUpButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(date) { _, date in
                UserProfileManager.shared.birthday = date.0 + date.1 + date.2
                let signUp = UserProfileManager.shared
                return UserRequest.Join(email: signUp.email,
                                  password: signUp.password,
                                  nick: signUp.nick,
                                  phoneNum: signUp.phone,
                                  birthDay: signUp.birthday)
            }
            .flatMap { NetworkManager.shared.callAPI(type: UserResponse.Join.self, router: Router.user(.join(query: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    print("회원가입 성공!")
                    signUpButtonTapTrigger.accept(())
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            viewWillAppearTrigger: input.viewWillAppearTrigger.asDriver(),
            nextMonthField: nextMonthField.asDriver(onErrorDriveWith: .empty()),
            nextDayField: nextDayField.asDriver(onErrorDriveWith: .empty()),
            isValid: isValid.asDriver(onErrorJustReturn: false),
            description: description.asDriver(onErrorJustReturn: "유효한 생년월일이 아닙니다."),
            signUpButtonTapTrigger: signUpButtonTapTrigger.asDriver(onErrorJustReturn: ()))
    }
    
}
