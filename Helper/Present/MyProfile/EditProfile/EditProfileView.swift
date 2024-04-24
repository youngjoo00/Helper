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
    
    let profileInfoTableView = BaseTableView().then {
        $0.register(EditProfileTableViewCell.self, forCellReuseIdentifier: EditProfileTableViewCell.id)
    }
    
    override func configureHierarchy() {
        [
            profileInfoTableView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        profileInfoTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}
