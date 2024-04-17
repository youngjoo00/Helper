//
//  NicknameView.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/31/24.
//

import UIKit
import Then
import RxSwift

final class NicknameView: BaseView {
    
    let titleLabel = PointBoldLabel("닉네임 등록하기", fontSize: 30)
    let nicknameTextField = PointTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = RedColorLabel("", fontSize: 15)
    
    override func configureHierarchy() {
        [
            titleLabel,
            nicknameTextField,
            descriptionLabel,
            nextButton,
        ].forEach { addSubview($0) }
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func configureView() {
        
    }
}
