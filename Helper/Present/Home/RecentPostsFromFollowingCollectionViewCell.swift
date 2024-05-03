//
//  RecentPostsFromFollowingCollectionViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class RecentPostsFromFollowingCollectionViewCell: BaseCollectionViewCell {
   
    private let postsKindLabel = PointBackgroundLabel(fontSize: 15)
    private let profileImageView = ProfileImageView()
    private let nicknameLabel = PointBoldLabel("닉네임", fontSize: 15)

    private let feedImageView = lightGrayBackgroundImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    override func configureHierarchy() {
        [
            profileImageView,
            nicknameLabel,
            feedImageView,
            postsKindLabel,
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.leading.equalToSuperview().offset(3)
            make.size.equalTo(25)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-1)
        }
        
        postsKindLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(feedImageView)
        }
        
        feedImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension RecentPostsFromFollowingCollectionViewCell {
    
    func updateView(_ data: PostResponse.FetchPost) {
        profileImageView.loadImage(urlString: data.creator.profileImage)
        nicknameLabel.text = data.creator.nick
        feedImageView.loadImage(urlString: data.files.first ?? "")
        
        if data.checkedPostsKind {
            postsKindLabel.text = "Feed"
        } else {
            postsKindLabel.text = "Help"
        }
    }
}
