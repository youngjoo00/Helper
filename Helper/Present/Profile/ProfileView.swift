//
//  ProfileView.swift
//  Helper
//
//  Created by youngjoo on 4/30/24.
//

import UIKit
import Then

final class ProfileView: BaseView {
    
    let profileImageView = ProfileImageView()
    let nicknameLabel = PointBoldLabel(fontSize: 20)
    
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
    
    override func configureHierarchy() {
        [
            profileImageView,
            nicknameLabel,
            contentStackView,
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
            make.height.equalTo(20)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
        }
    }
    
    override func configureView() {
        
    }
}

extension ProfileView {
    
    func updateView<T: ProfileDisplayable>(_ profileData: T) {
        profileImageView.loadImage(urlString: profileData.profileImage)
        nicknameLabel.text = profileData.nick
        postsValueLabel.text = profileData.posts.count.description
        followingValueLabel.text = profileData.following.count.description
        followersValueLabel.text = profileData.followers.count.description
    }
}
