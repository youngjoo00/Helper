//
//  MyProfileView.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Tabman
import Then

final class MyProfileView: BaseView {
    
    let nicknameLabel = PointBoldLabel("test님, 안녕하세요", fontSize: 20)
    let profileEditButton = PointButton(title: "프로필 수정")
    
    let containerView = UIView()
    
    override func configureHierarchy() {
        [
            nicknameLabel,
            profileEditButton,
            containerView,
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    override func configureView() {
        
    }
}
