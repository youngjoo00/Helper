//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    
    private let mainView = SignUpView()
    private let viewModel = SignUpViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        let input = SignUpViewModel.Input(email: mainView.emailTextField.rx.text.orEmpty.asObservable(),
                                          validationButtonTap: mainView.validationButton.rx.tap,
                                          nextButtonTapped: mainView.nextButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.validEmail
            .drive(with: self) { owner, valid in
                print(valid)
                if valid {
                    owner.showAlert(title: "성공!", message: nil)
                } else {
                    owner.showAlert(title: "실패!", message: nil)
                }
            }
            .disposed(by: disposeBag)
        
        output.nextButtonTapped
            .drive(with: self) { owner, email in
                SignUp.shared.email = email
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
