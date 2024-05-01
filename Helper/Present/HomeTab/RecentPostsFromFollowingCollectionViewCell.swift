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
   
    private let profileImageView = ProfileImageView()
    private let nicknameLabel = PointBoldLabel("닉네임", fontSize: 15)

    private let feedImageView = lightGrayBackgroundImageView()
    
    override func configureHierarchy() {
        [
            profileImageView,
            nicknameLabel,
            feedImageView,
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
        feedImageView.loadImage(urlString: data.files[0])
    }
}
