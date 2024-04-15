//
//  MyPostCollectionViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/14/24.
//

import UIKit
import Then
import Kingfisher

final class MyPostCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = UIImageView().then {
        $0.backgroundColor = .lightGray
    }
    let titleLabel = PointLabel("test", fontSize: 17)
    let contentLabel = PointLabel("test", fontSize: 15)
    
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
    }
    
    override func configureHierarchy() {
        [
            imageView,
            titleLabel,
            contentLabel,
            activityIndicator
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
    }
    
    override func configureView() {
        backgroundColor = .lightGray
    }
}

extension MyPostCollectionViewCell {
    
    func updateCell(_ data: ResponseModel.PostID) {
        activityIndicator.startAnimating()
        
        if imageView.loadImage(urlString: data.files[0]) {
            activityIndicator.stopAnimating()
        }
        
        titleLabel.text = data.title
        contentLabel.text = data.content
    }
}
