//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa

enum NicknameViewMode {
    case signUp
    case profileEdit
}

final class NicknameViewController: BaseViewController {
    
    private let mainView = NicknameView()
    private let viewModel = NicknameViewModel()
    var viewMode = NicknameViewMode.signUp
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let input = NicknameViewModel.Input(nickname: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
                                            nextButtonTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.isValid
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        output.nextButtonTapTrigger
            .drive(with: self) { owner, _ in
                switch owner.viewMode {
                case .signUp:
                    owner.transition(viewController: PhoneViewController(), style: .push)
                case .profileEdit:
                    owner.navigationController?.popViewController(animated: true)
                }
                
            }
            .disposed(by: disposeBag)

        
    }
    
}
