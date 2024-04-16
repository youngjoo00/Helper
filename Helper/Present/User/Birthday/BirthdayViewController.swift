//
//  BirthdayViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class BirthdayViewController: BaseViewController {
    
    private let mainView = BirthdayView()
    private let viewModel = BirthdayViewModel()
        
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = BirthdayViewModel.Input(year: mainView.yearTextField.rx.text.orEmpty.asObservable(),
                                            month: mainView.monthTextField.rx.text.orEmpty.asObservable(),
                                            day: mainView.dayTextField.rx.text.orEmpty.asObservable(),
                                            signUpButtonTap: mainView.signUpButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.isValid
            .drive(mainView.signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        output.signUpButtonTapTrigger
            .drive(with: self) { owner, _ in
                owner.showAlert(title: "축하합니다!", message: "회원가입에 성공했습니다.") {
                    owner.changeSignInRootView()
                }
            }
            .disposed(by: disposeBag)

    }
    
}
