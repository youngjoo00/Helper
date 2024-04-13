//
//  SignUpViewModel.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 4/3/24.
//

import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    
    var disposeBag: DisposeBag = .init()
    
    struct Input {
        let email: Observable<String>
        let nextButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let isEmailValid: Driver<Bool>
        let isEmailUnique: Driver<Bool>
        let description: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let isEmailValid = BehaviorRelay(value: false)
        let isEmailUnique = PublishRelay<Bool>()
        let description = PublishRelay<String>()
  
        // 이메일 정규식 체크
        input.email
            .subscribe(with: self) { owner, email in
                let validate = owner.validateEmail(email)
                if validate {
                    description.accept("")
                } else {
                    description.accept("유효한 이메일 형식이 아닙니다.")
                }
                isEmailValid.accept(validate)
            }
            .disposed(by: disposeBag)
        
        // 이메일 중복확인
        input.nextButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.email)
            .map { RequestModel.ValidationEmail(email: $0) }
            .flatMap { email in
                NetworkManager.shared.callAPI(type: ResponseModel.ValidationEmail.self, router: .validationEmail(query: email))
                    .map { (email, $0) }
            }
            .subscribe(with: self) { owner, result in
                let (email, response) = result
                switch response {
                case .success(let data):
                    print(data.message)
                    SignUp.shared.email = email.email
                    isEmailUnique.accept(true)
                case .fail(let fail):
                    print(fail)
                    description.accept(fail.localizedDescription)
                case .errorMessage(let error):
                    print(error)
                    description.accept(error.message)
                }
            } onDisposed: { _ in
                print("buttonDispose")
            }
            .disposed(by: disposeBag)

        return Output(
            isEmailValid: isEmailValid.asDriver(onErrorJustReturn: false),
            isEmailUnique: isEmailUnique.asDriver(onErrorJustReturn: false),
            description: description.asDriver(onErrorJustReturn: "")
        )
    }
    
}
