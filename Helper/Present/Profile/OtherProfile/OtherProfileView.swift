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
    let followingLabel = PointLabel("팔로워", fontSize: 18)
    let followingValueLabel = PointBoldLabel(fontSize: 20)
    
    lazy var followerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
        $0.addGestureRecognizer(followersTapGesture)
        $0.isUserInteractionEnabled = true
    }
    
    let followersTapGesture = UITapGestureRecognizer()
    let followersLabel = PointLabel("팔로잉", fontSize: 18)
    let followersValueLabel = PointBoldLabel(fontSize: 20)
    
    let followButton = PointButton(title: "팔로우")
    
    let profilePostsLabel = PointBoldLabel("게시물", fontSize: 17)
    let profilePostsView = ProfilePostsView()
    
    override func configureHierarchy() {
        [
            profileImageView,
            nicknameLabel,
            contentStackView,
            followButton,
            profilePostsLabel,
            profilePostsView
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
        
        followButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
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
    
    func updateView(_ profileData: UserResponse.OtherProfile) {
        profileImageView.loadImage(urlString: profileData.profileImage)
        nicknameLabel.text = profileData.nick
        postsValueLabel.text = profileData.posts.count.description
        followingValueLabel.text = profileData.following.count.description
        followersValueLabel.text = profileData.followers.count.description
    }
    
    func updateFollowButton(_ data: Bool) {
        if data {
            followButton.configureView("팔로잉", image: UIImage(systemName: "checkmark"))
        } else {
            followButton.configureView("팔로우", image: nil)
        }
    }
}
