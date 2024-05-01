//
//  FollowTableViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class FollowTableViewCell: BaseTableViewCell {
   
    private let profileImageView = ProfileImageView()
    private let nicknameLabel = PointBoldLabel("닉네임", fontSize: 18)
    let followButton = FollowButton()
    
    override func configureHierarchy() {
        [
            profileImageView,
            nicknameLabel,
            followButton,
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.size.equalTo(60)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
    
    override func configureView() {
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension FollowTableViewCell {
    
    func updateView(_ data: DisplayFollow) {
        profileImageView.loadImage(urlString: data.follow.profileImage)
        nicknameLabel.text = data.follow.nick
        updateFollowButton(data.isFollowing)
    }
    
    private func updateFollowButton(_ data: Bool) {
        followButton.configureView(data)
    }
}
