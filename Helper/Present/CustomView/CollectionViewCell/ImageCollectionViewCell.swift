//
//  ImageCollectionViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/17/24.
//

import UIKit
import Then
import Kingfisher

final class ImageCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = lightGrayBackgroundImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    override func configureHierarchy() {
        [
            imageView,
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}

extension ImageCollectionViewCell {
    
    func updateImageView(_ urlString: String) {
        imageView.loadImage(urlString: urlString)
    }
}
