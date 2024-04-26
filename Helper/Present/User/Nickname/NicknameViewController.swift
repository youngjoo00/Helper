//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa

final class NicknameViewController: BaseViewController {
    
    private let mainView = NicknameView()
    private let viewModel = NicknameViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = NicknameViewModel.Input(
            viewWillAppearTrigger: self.rx.viewWillAppear,
            nickname: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
            nextButtonTap: mainView.nextButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.viewWillAppearTrigger
            .drive(mainView.nicknameTextField.rx.becomeFirstResponder)
            .disposed(by: disposeBag)
        
        output.isValid
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        output.nextButtonTapTrigger
            .drive(with: self) { owner, _ in
                owner.transition(viewController: PhoneViewController(), style: .push)
            }
            .disposed(by: disposeBag)

        
    }
    
}
