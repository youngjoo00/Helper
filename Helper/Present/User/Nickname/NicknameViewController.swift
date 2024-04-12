//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
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

        print(SignUp.shared)
    }
    
    override func bind() {
        
        let input = NicknameViewModel.Input(nickname: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
                                            nextButtonTap: mainView.nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.valid
            .drive(mainView.descriptionLabel.rx.isHidden, mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Button
        output.nextButtonTap
            .bind(with: self) { owner, _ in
                
            }
            .disposed(by: disposeBag)
        
        output.valid
            .map { $0 ? UIColor.systemPink : UIColor.lightGray }
            .drive(mainView.nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
}
