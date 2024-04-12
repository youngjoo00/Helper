//
//  PasswordView.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/28/24.
//

import UIKit
import Then
import RxSwift

final class PasswordView: BaseView {
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()

    
    override func configureHierarchy() {
        [
            passwordTextField,
            descriptionLabel,
            nextButton,
        ].forEach { addSubview($0) }
    }

    override func configureLayout() {
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        

    }
    
    
    override func configureView() {
        
    }
}
