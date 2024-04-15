//
//  BirthdayView.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Then
import RxSwift

final class BirthdayView: BaseView {
    
    let titleLabel = PointBoldLabel("생년월일 등록하기", fontSize: 30)
    let yearTextField = SignTextField(placeholderText: "YYYY")
    let monthTextField = SignTextField(placeholderText: "MM")
    let dayTextField = SignTextField(placeholderText: "DD")
    let signUpButton = PointButton(title: "다음")
    let descriptionLabel = RedColorLabel("", fontSize: 15)
    
    override func configureHierarchy() {
        [
            titleLabel,
            yearTextField,
            monthTextField,
            dayTextField,
            descriptionLabel,
            signUpButton,
        ].forEach { addSubview($0) }
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        
        yearTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(100)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.trailing.equalTo(monthTextField.snp.leading).offset(-10)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(100)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        dayTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(100)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(monthTextField.snp.trailing).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(monthTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(monthTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        
    }
}