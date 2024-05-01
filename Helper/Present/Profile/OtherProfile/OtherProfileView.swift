//
//  OtherProfileView.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Tabman
import Then

class OtherProfileView: BaseView {
    
    let profileView = ProfileView()
    let followButton = PointButton(title: "팔로우")
    
    let profilePostsLabel = PointBoldLabel("게시물", fontSize: 17)
    let profilePostsView = ProfilePostsView()
    
    override func configureHierarchy() {
        [
            profileView,
            followButton,
            profilePostsLabel,
            profilePostsView
        ].forEach { addSubview($0) }
        
    }
    
    override func configureLayout() {
        
        profileView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(160)
        }
        
        followButton.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        profilePostsLabel.snp.makeConstraints { make in
            make.top.equalTo(followButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        profilePostsView.snp.makeConstraints { make in
            make.top.equalTo(profilePostsLabel.snp.bottom).offset(15)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
    }
    
    override func configureView() {
        
    }
}

extension OtherProfileView {
    
    func updateFollowButton(_ data: Bool) {
        if data {
            followButton.configureView("팔로잉", image: UIImage(systemName: "checkmark"))
        } else {
            followButton.configureView("팔로우", image: nil)
        }
    }
}
