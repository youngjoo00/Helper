//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/28/24.
//

import UIKit
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
                                          nextButtonTapped: mainView.nextButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 이메일 정규식
        output.isEmailValid
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // 이메일 중복 통과라면 다음 화면
        output.isEmailUnique
            .drive(with: self) { owner, value in
                if value {
                    owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
