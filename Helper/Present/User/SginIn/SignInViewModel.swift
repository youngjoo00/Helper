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
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let loginValid = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
        
        let loginQuery = Observable.combineLatest(input.emailText, input.passwordText)
            .map { email, password in
                UserRequest.Login(email: email, password: password)
            }
        
        input.loginButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginQuery)
            .flatMap { NetworkManager.shared.callAPI(type: UserResponse.Login.self, router: Router.user(.login(query: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    UserDefaultsManager.shared.saveTokens(data.accessToken, refreshToken: data.refreshToken)
                    UserDefaultsManager.shared.saveUserID(data.userID)
                    loginValid.accept(true)
                case .fail(let fail):
                    errorMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)

        return Output(loginValid: loginValid.asDriver(onErrorJustReturn: false),
                      signUpButtonTapped: input.signUpButtonTapped.asDriver(),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: "알 수 없는 오류로 인해 로그인에 실패했습니다")
        )
    }
    
}
