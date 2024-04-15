//
//  PostCollectionViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit
import Then
import Kingfisher

final class PostCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = UIImageView().then {
        $0.backgroundColor = .lightGray
    }
    let titleLabel = PointBoldLabel(nil, fontSize: 17)
    let pointLabel = PointLabel(nil, fontSize: 15)
    let dateLabel = PointLabel(nil, fontSize: 15)
    let locateLabel = PointLabel(nil, fontSize: 15)
    
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
    }
    
    override func configureHierarchy() {
        [
            imageView,
            titleLabel,
            pointLabel,
            dateLabel,
            locateLabel,
            activityIndicator
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        pointLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(pointLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        locateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(imageView)
        }
    }
    
    override func configureView() {
        
    }
}

extension PostCollectionViewCell {
    
    func updateCell(_ data: ResponseModel.PostID) {
        activityIndicator.startAnimating()
        
        if imageView.loadImage(urlString: data.files[0]) {
            activityIndicator.stopAnimating()
        }
        
        titleLabel.text = data.title
        pointLabel.text = data.content1
        dateLabel.text = data.content2
        locateLabel.text = data.content3
    }
}