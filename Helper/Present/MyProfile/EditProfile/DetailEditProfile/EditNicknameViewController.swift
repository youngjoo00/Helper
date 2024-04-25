//
//  EditNicknameViewController.swift
//  Helper
//
//  Created by youngjoo on 4/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class EditNicknameViewController: BaseViewController {
    
    private let mainView = NicknameView()
    private let viewModel = NicknameViewModel()
    
    init(nickname: String) {
        mainView.nicknameTextField.text = nickname
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.configureEditProfileView()
    }
    
    override func bind() {

        let input = NicknameViewModel.Input(
            nickname: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
            nextButtonTap: mainView.nextButton.rx.tap
        )
        
        let output = viewModel.editTransform(input: input)
        
        output.isValid
            .drive(mainView.nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.description
            .drive(mainView.descriptionLabel.rx.text)
            .disposed(by: disposeBag)

        output.successTrigger
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(with: self) { owner, message in
                owner.showTaost(message)
            }
            .disposed(by: disposeBag)

    }
    
}
