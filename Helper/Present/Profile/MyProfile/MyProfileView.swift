//
//  MyProfileView.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Then

final class MyProfileView: BaseView {

    let profileView = ProfileView()
    let profileEditButton = BoldTextPointButton(title: "프로필 수정", size: 17)
    let containerView = UIView()
    
    override func configureHierarchy() {
        
        [
            profileView,
            profileEditButton,
            containerView,
        ].forEach { addSubview($0) }
        
    }
    
    override func configureLayout() {
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(160)
        }
        
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.height.equalTo(44)
            make.width.equalTo(150)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(profileEditButton.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    override func configureView() {
        
    }
    
}
