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
    let titleLabel = PointBoldLabel(fontSize: 17)
    let featureLabel = PointLabel(fontSize: 15)
    let dateLabel = PointLabel(fontSize: 15)
    let locateLabel = PointLabel(fontSize: 15)
    
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
    }
    
    override func configureHierarchy() {
        [
            imageView,
            titleLabel,
            featureLabel,
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
        
        featureLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(featureLabel.snp.bottom).offset(5)
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
    
    func updateView(_ data: PostResponse.FetchPost) {
        activityIndicator.startAnimating()
        
        imageView.loadImage(urlString: data.files[0]) { [weak self] result in
            guard let self else { return }
            if result {
                activityIndicator.stopAnimating()
            } else {
                // 실패케이스 처리 고민합시다
            }
            
        }
        
        titleLabel.text = data.title
        featureLabel.text = data.feature
        dateLabel.text = data.date
        locateLabel.text = data.locate
    }
}
