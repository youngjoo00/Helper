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
         
        print(SignUp.shared.email)
    }

    override func bind() {
        
        let input = PasswordViewModel.Input(password: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
                                            nextButtonTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.nextButtonTap
            .drive(with: self) { owner, password in
                SignUp.shared.password = password
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.valid
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.valid
            .map { $0 ? UIColor.systemPink : UIColor.lightGray }
            .drive(mainView.nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}
