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
                                            nextButtonTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.nextButtonTapTrigger
            .drive(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isValid
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
