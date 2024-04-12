//
//  SignInViewController.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//

import UIKit
import SnapKit
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
        
        // RxCocoa 는 UIKit 기반인데 이게 싫으면 아예 옵저버블 타입으로 넘겨버림
        let input = SignInViewModel.Input(emailText: mainView.emailTextField.rx.text.orEmpty.asObservable(),
                                          passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
                                          loginButtonTapped: mainView.signInButton.rx.tap,
                                          joinButtonTapped: mainView.signUpButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.loginValid
            .drive(with: self) { owner, valid in
                if valid {
                    //owner.showAlert(title: "로그인 성공!", message: nil)
                } else {
                    //owner.showAlert(title: "로그인 실패!", message: nil)
                }
            }
            .disposed(by: disposeBag)
        
        output.joinButtonTapped
            .drive(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
