//
//  SignUpView.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/28/24.
//

import UIKit
import Then
import RxSwift

final class SignUpView: BaseView {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(Color.black, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Color.black.cgColor
        $0.layer.cornerRadius = 10
    }
    
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    override func configureHierarchy() {
        [
            emailTextField,
            validationButton,
            descriptionLabel,
            nextButton,
        ].forEach { addSubview($0) }
    }

    override func configureLayout() {
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }

    }
    
    
    override func configureView() {
        
    }
}
