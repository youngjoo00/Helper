//
//  SignInView.swift
//  Helper
//
//  Created by youngjoo on 4/12/24.
//

import UIKit
import Then

final class SignInView: BaseView {
    
    let logoTitle = PointBoldLabel("Helper", fontSize: 40)
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = PointButton(title: "회원가입")
    
    override func configureHierarchy() {
        [
            logoTitle,
            emailTextField,
            passwordTextField,
            signInButton,
            signUpButton,
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        logoTitle.snp.makeConstraints { make in
            make.bottom.equalTo(emailTextField.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
    }
    
    override func configureView() {
        
    }
}
