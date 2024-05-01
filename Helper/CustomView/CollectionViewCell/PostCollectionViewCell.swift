//
//  PostCollectionViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit
import Then
import Kingfisher
import RxSwift

final class PostCollectionViewCell: BaseCollectionViewCell {
    
    let postsCompleteLabel = PointBackgroundLabel(fontSize: 17)
    
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
            postsCompleteLabel,
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
        
        postsCompleteLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension PostCollectionViewCell {
    
    func updateView(_ data: PostResponse.FetchPost) {
        imageView.loadImage(urlString: data.files[0])
        
        if (!data.complete.isEmpty) {
            postsCompleteLabel.text = "완료"
            postsCompleteLabel.isHidden = false
        } else {
            postsCompleteLabel.text = ""
            postsCompleteLabel.isHidden = true
        }
        
        titleLabel.text = data.title
        dateLabel.text = data.date
        featureLabel.text = data.feature
        
        let featureTextIsEmpty = data.feature.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        // featureLabel의 텍스트 여부에 따라 레이아웃 조정
        if featureTextIsEmpty {
            dateLabel.snp.remakeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.leading.equalTo(dateImageView.snp.trailing).offset(5)
                make.trailing.equalToSuperview().offset(-5)
            }
        } else {
            dateLabel.snp.remakeConstraints { make in
                make.top.equalTo(featureLabel.snp.bottom).offset(5)
                make.leading.equalTo(dateImageView.snp.trailing).offset(5)
                make.trailing.equalToSuperview().offset(-5)
            }
        }
        
        locateLabel.text = data.locate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "없음" : data.locate
    }

}
