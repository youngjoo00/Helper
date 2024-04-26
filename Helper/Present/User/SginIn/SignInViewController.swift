//
//  SignInViewController.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: BaseViewController {

    private let mainView = SignInView()
    private let viewModel = SignInViewModel()
 
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = SignInViewModel.Input(emailText: mainView.emailTextField.rx.text.orEmpty.asObservable(),
                                          passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
                                          loginButtonTapped: mainView.signInButton.rx.tap,
                                          signUpButtonTapped: mainView.signUpButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.loginValid
            .drive(with: self) { owner, valid in
                if valid {
                    owner.changeHomeRootView()
                } else {
                    owner.showAlert(title: "로그인 실패!", message: nil)
                }
            }
            .disposed(by: disposeBag)
        
        output.signUpButtonTapped
            .drive(with: self) { owner, _ in
                owner.transition(viewController: SignUpViewController(), style: .push)
            }
            .disposed(by: disposeBag)
    }
}

