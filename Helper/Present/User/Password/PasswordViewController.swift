//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordViewController: BaseViewController {
   
    private let mainView = PasswordView()
    private let viewModel = PasswordViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func bind() {
        
        let input = PasswordViewModel.Input(password: mainView.passwordTextField.rx.text.orEmpty.asObservable(), 
                                            secondPassword: mainView.secondPasswordTextField.rx.text.orEmpty.asObservable(),
                                            nextButtonTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.secondDescription
            .drive(mainView.secondDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.enableButton
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.nextButtonTapTrigger
            .drive(with: self) { owner, _ in
                owner.transition(viewController: NicknameViewController(), style: .push)
            }
            .disposed(by: disposeBag)
    }
}
