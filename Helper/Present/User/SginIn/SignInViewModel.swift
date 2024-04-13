//
//  SignInViewModel.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInViewModel: ViewModelType {
    
    var disposeBag: DisposeBag = .init()
    
    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let loginButtonTapped: ControlEvent<Void>
        let signUpButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let loginValid: Driver<Bool>
        let signUpButtonTapped: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let loginValid = PublishRelay<Bool>()
        
        let loginQuery = Observable.combineLatest(input.emailText, input.passwordText)
            .map { email, password in
                RequestModel.Login(email: email, password: password)
            }
        
        input.loginButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginQuery)
            .flatMap { NetworkManager.shared.callAPI(type: ResponseModel.Login.self, router: .login(query: $0)) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    loginValid.accept(true)
                    print("로그인 성공!", data.accessToken, data.refreshToken)
                    UserDefaultsManager.shared.saveTokens(data.accessToken, refreshToken: data.refreshToken)
                case .fail(let fail):
                    loginValid.accept(false)
                    print(fail.localizedDescription)
                case .errorMessage(let message):
                    loginValid.accept(false)
                    print(message.message)
                }
            } onError: { _, error in
                print(error, "onError 등장")
            } onDisposed: { _ in
                print("disepose 됨")
            }
            .disposed(by: disposeBag)

        return Output(loginValid: loginValid.asDriver(onErrorJustReturn: false),
                      signUpButtonTapped: input.signUpButtonTapped.asDriver()
        )
    }
    
}
