//
//  PhoneViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PhoneViewController: BaseViewController {
    
    private let mainView = PhoneView()
    private let viewModel = PhoneViewModel()
        
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = PhoneViewModel.Input(
            phone: mainView.phoneTextField.rx.text.orEmpty.asObservable(),
            nextButtonTap: mainView.nextButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.isValid
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        output.nextButtonTapTrigger
            .drive(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }
            .disposed(by: disposeBag)

    }
    
}
