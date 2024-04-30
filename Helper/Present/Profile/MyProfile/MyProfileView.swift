//
//  MyProfileView.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Tabman
import Then

class MyProfileView: BaseView {
    
    let profileImageView = ProfileImageView()
    let nicknameLabel = PointBoldLabel(fontSize: 20)
    let profileEditButton = PointButton(title: "프로필 수정")
    
    let contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 20
        $0.alignment = .center
    }
    
    let postsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
    }
    
    let postsLabel = PointLabel("게시물", fontSize: 18)
    let postsValueLabel = PointBoldLabel(fontSize: 20)
    
    lazy var followingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
        $0.addGestureRecognizer(followingTapGesture)
        $0.isUserInteractionEnabled = true
    }
    
    let followingTapGesture = UITapGestureRecognizer()
    let followingLabel = PointLabel("팔로잉", fontSize: 18)
    let followingValueLabel = PointBoldLabel(fontSize: 20)
    
    lazy var followerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
        $0.addGestureRecognizer(followersTapGesture)
        $0.isUserInteractionEnabled = true
    }
    
    let followersTapGesture = UITapGestureRecognizer()
    let followersLabel = PointLabel("팔로워", fontSize: 18)
    let followersValueLabel = PointBoldLabel(fontSize: 20)
    
    let containerView = UIView()
    
    override func configureHierarchy() {
        [
            profileImageView,
            nicknameLabel,
            contentStackView,
            profileEditButton,
            containerView,
        ].forEach { addSubview($0) }
        
        [
            postsStackView,
            followerStackView,
            followingStackView,
        ].forEach { contentStackView.addArrangedSubview($0) }
        
        [
            postsLabel,
            postsValueLabel
        ].forEach { postsStackView.addArrangedSubview($0) }
        
        [
            followersLabel,
            followersValueLabel,
        ].forEach { followerStackView.addArrangedSubview($0) }
        
        [
            followingLabel,
            followingValueLabel
        ].forEach { followingStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.size.equalTo(100)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
        }
        
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
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

extension MyProfileView {
    
    func updateView(_ profileData: UserResponse.MyProfile) {
        profileImageView.loadImage(urlString: profileData.profileImage)
        nicknameLabel.text = profileData.nick
        postsValueLabel.text = profileData.posts.count.description
        followingValueLabel.text = profileData.following.count.description
        followersValueLabel.text = profileData.followers.count.description
    }
}
