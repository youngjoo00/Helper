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
        let year: Observable<String>
        let month: Observable<String>
        let day: Observable<String>
        let signUpButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isValid: Driver<Bool>
        let description: Driver<String>
        let signUpButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let signUpButtonTapTrigger = PublishRelay<Void>()

        // 세개의 값이 다 들어온 경우 확인 시작
        let date = Observable.combineLatest(input.year, input.month, input.day)
        
        let isValid = date
            .map { year, month, day in
                guard let year = Int(year), let month = Int(month), let day = Int(day) else { return false }
                return DateManager.shared.validationDate(year: year, month: month, day: day)
            }
        
        let description = isValid
            .map { $0 ? "" : "유효한 생년월일이 아닙니다." }
        
        input.signUpButtonTap
            .withLatestFrom(date) { _, date in
                SignUpManager.shared.birthday = date.0 + date.1 + date.2
                let signUp = SignUpManager.shared
                return RequestModel.Join(email: signUp.email,
                                  password: signUp.password,
                                  nick: signUp.nick,
                                  phone: signUp.phone,
                                  birthday: signUp.birthday)
            }
            .flatMap { NetworkManager.shared.callAPI(type: ResponseModel.Join.self, router: Router.user(.join(query: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print("회원가입 성공!")
                    signUpButtonTapTrigger.accept(())
                case .fail(let fail):
                    print(fail)
                case .errorMessage(let message):
                    print(message)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(isValid: isValid.asDriver(onErrorJustReturn: false),
                      description: description.asDriver(onErrorJustReturn: "유효한 생년월일이 아닙니다."),
                      signUpButtonTapTrigger: signUpButtonTapTrigger.asDriver(onErrorJustReturn: ()))
    }
    
}
