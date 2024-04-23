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
    
    let imageView = lightGrayBackgroundImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    let titleLabel = PointBoldLabel(fontSize: 17)
    let featureLabel = PointLabel(fontSize: 15)
    
    let locateImageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse")).then {
        $0.tintColor = .black
    }
    let locateLabel = PointLabel(fontSize: 15)
    
    let dateImageView = UIImageView(image: UIImage(systemName: "calendar")).then {
        $0.tintColor = .black
    }
    let dateLabel = PointLabel(fontSize: 15)


    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
    }
    
    override func configureHierarchy() {
        [
            imageView,
            titleLabel,
            featureLabel,
            dateImageView,
            dateLabel,
            locateImageView,
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
            make.horizontalEdges.equalToSuperview().inset(5)
        }
        
        featureLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview().inset(5)
        }
        
        dateImageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel)
            make.leading.equalToSuperview().offset(5)
            make.size.equalTo(18)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(featureLabel.snp.bottom).offset(5)
            make.leading.equalTo(dateImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
        
        locateImageView.snp.makeConstraints { make in
            make.top.equalTo(locateLabel)
            make.leading.equalToSuperview().offset(5)
            make.size.equalTo(18)
        }
        
        locateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.leading.equalTo(locateImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-5)
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
        imageView.loadImage(urlString: data.files[0])
        
        titleLabel.text = data.title
        dateLabel.text = data.date
        
        checkEmptyData(data)
    }

    private func checkEmptyData(_ data: PostResponse.FetchPost) {
        let featureIsEmpty = data.feature.isEmpty
        
        if featureIsEmpty {
            featureLabel.snp.remakeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom)
                make.horizontalEdges.equalToSuperview().inset(5)
                make.height.equalTo(0)
            }
            
            dateLabel.snp.remakeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.leading.equalTo(dateImageView.snp.trailing).offset(5)
                make.trailing.equalToSuperview().offset(-5)
            }
        } else {
            featureLabel.text = data.feature
        }

        // trimmingCharacters 으로 공백 문자, 줄바꿈문자를 제외시키고 남은 문자열이 비어있는지 확인
        locateLabel.text = data.locate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "없음" : data.locate

    }
    
}
