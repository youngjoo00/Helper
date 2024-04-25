//
//  EditNicknameViewController.swift
//  Helper
//
//  Created by youngjoo on 4/25/24.
//

import UIKit
import RxSwift
import RxCocoa

final class EditPhoneViewController: BaseViewController {
    
    private let mainView = PhoneView()
    private let viewModel = PhoneViewModel()
    
    init(phone: String) {
        mainView.phoneTextField.text = phone
        super.init(nibName: nil, bundle: nil) // 아래에 부모 초기화구문을 넣어야하네??
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
        
//        // 오 뭐야 여기서 이벤트 읽네??
//        mainView.phoneTextField.rx.text.orEmpty
//            .subscribe(with: self) { owner, text in
//                print(text)
//            }
//            .disposed(by: disposeBag)
        
        let input = PhoneViewModel.Input(phone: mainView.phoneTextField.rx.text.orEmpty.asObservable(),
                                            nextButtonTap: mainView.nextButton.rx.tap)
        
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
