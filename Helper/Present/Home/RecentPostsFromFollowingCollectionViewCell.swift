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
    private let nicknameLabel = PointBoldLabel("닉네임", fontSize: 18)

    private let postsImage = lightGrayBackgroundImageView()
    
    override func configureHierarchy() {
        [
            profileImageView,
            nicknameLabel,
            postsImage,
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.size.equalTo(30)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
        }
        
        postsImage.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.bottom.horizontalEdges.equalToSuperview()
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
        profileImageView.loadImage(urlString: "")
        nicknameLabel.text = data.creator.nick
    }
}
