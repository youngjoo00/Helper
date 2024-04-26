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
    
    let titleLabel = PointBoldLabel("비밀번호 등록하기", fontSize: 30)
    let passwordTextField = PointTextField(placeholderText: "비밀번호를 입력해주세요").then {
        $0.isSecureTextEntry = true
    }
    
    let descriptionLabel = RedColorLabel("", fontSize: 15)
    
    let secondPasswordTextField = PointTextField(placeholderText: "비밀번호 재입력").then {
        $0.isSecureTextEntry = true
    }
    
    let nextButton = PointButton(title: "다음")
    
    let secondDescriptionLabel = RedColorLabel("", fontSize: 15)
    
    override func configureHierarchy() {
        [
            titleLabel,
            passwordTextField,
            descriptionLabel,
            secondPasswordTextField,
            secondDescriptionLabel,
            nextButton,
        ].forEach { addSubview($0) }
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        secondPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        secondDescriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(secondPasswordTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(secondDescriptionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    
    override func configureView() {
        
    }
}
