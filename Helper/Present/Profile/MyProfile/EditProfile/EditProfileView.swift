//
//  EditProfileView.swift
//  Helper
//
//  Created by youngjoo on 4/24/24.
//

import UIKit
import Then

final class EditProfileView: BaseView {
    
    let naviTitle = PointBoldLabel("프로필 편집", fontSize: 18)
    
    let profileImageView = ProfileImageView()
    let editProfileImageButton = PointButton(title: "프로필 사진 수정")
    let profileInfoTableView = BaseTableView().then {
        $0.register(EditProfileTableViewCell.self, forCellReuseIdentifier: EditProfileTableViewCell.id)
    }
    
    override func configureHierarchy() {
        [
            profileImageView,
            editProfileImageButton,
            profileInfoTableView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        editProfileImageButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        profileInfoTableView.snp.makeConstraints { make in
            make.top.equalTo(editProfileImageButton.snp.bottom).offset(30)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}

extension EditProfileView {
    
    func updateProfileImageView(_ urlString: String) {
        profileImageView.loadImage(urlString: urlString)
    }
}
