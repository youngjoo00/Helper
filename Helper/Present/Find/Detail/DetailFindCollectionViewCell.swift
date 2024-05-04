//
//  DetailPostCollectionViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/19/24.
//

import UIKit
import Then
import Kingfisher

final class DetailFindCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = lightGrayBackgroundImageView()
        
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

extension DetailFindCollectionViewCell {
    
    func updateView(_ file: String) {
        imageView.loadImage(urlString: file)
    }
}
