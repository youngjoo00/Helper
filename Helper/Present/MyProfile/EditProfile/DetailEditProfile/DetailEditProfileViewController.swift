//
//  DetailEditProfileViewController.swift
//  Helper
//
//  Created by youngjoo on 4/24/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailEditProfileViewController: BaseViewController {

    private let nicknameView = NicknameView()
    private let viewModel = NicknameViewModel()
    
    override func loadView() {
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = NicknameViewModel.Input(
            nickname: nicknameView.nicknameTextField.rx.text.orEmpty.asObservable(),
            nextButtonTap: nicknameView.nextButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
    }
}
