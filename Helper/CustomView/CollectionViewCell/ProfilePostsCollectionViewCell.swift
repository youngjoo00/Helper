//
//  ProfilePostsCollectionViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/29/24.
//

import UIKit
import Then
import Kingfisher
import RxSwift

final class ProfilePostsCollectionViewCell: BaseCollectionViewCell {
    
    let postsKindLabel = PointBackgroundLabel(fontSize: 15)
    
    let imageView = lightGrayBackgroundImageView()
    
    override func configureHierarchy() {
        [
            imageView,
            postsKindLabel,
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        postsKindLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
    }
    
    override func configureView() {
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension ProfilePostsCollectionViewCell {
    
    func updateView(_ data: PostResponse.FetchPost) {
        imageView.loadImage(urlString: data.files[0])
        
        if data.checkedPostsKind {
            postsKindLabel.text = "Feed"
        } else {
            postsKindLabel.text = "Help"
        }
    }

}
