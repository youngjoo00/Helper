//
//  FeedTableViewCell.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import Then
import RxSwift

final class FeedTableViewCell: BaseTableViewCell {

    let profileTabGesture = UITapGestureRecognizer()
    lazy var profileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.addGestureRecognizer(profileTabGesture)
    }
    
    let profileImageView = ProfileImageView()
    let nicknameLabel = PointBoldLabel(fontSize: 18)
    let regDateLabel = PointLabel(fontSize: 15)

    let imageCollectionView = BaseCollectionView(frame: .zero, collectionViewLayout: .imageCollectionViewLayout()).then {
        $0.register(DetailPostCollectionViewCell.self, forCellWithReuseIdentifier: DetailPostCollectionViewCell.id)
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .gray
    }
    
    let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .black
        $0.pageIndicatorTintColor = .lightGray
    }
    
    let commentButton = ImageButton(image: UIImage(systemName: "message"))
    let storageButton = ImageButton(image: UIImage(systemName: "bookmark"))
    let titleLabel = PointLabel(fontSize: 16).then {
        $0.numberOfLines = 0
    }
    
    let hashTagLabel = PointLabel(fontSize: 15).then {
        $0.numberOfLines = 0
    }
    
    override func configureHierarchy() {
        [
            profileStackView,
            regDateLabel,
            imageCollectionView,
            storageButton,
            commentButton,
            pageControl,
            titleLabel,
            hashTagLabel,
        ].forEach { contentView.addSubview($0) }

        [
            profileImageView,
            nicknameLabel,
        ].forEach { profileStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        profileStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
        }
        
        regDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileStackView)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerY.equalTo(commentButton)
            make.centerX.equalToSuperview()
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(5)
            make.leading.equalTo(safeAreaLayoutGuide).offset(5)
            make.size.equalTo(44)
        }
        
        storageButton.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(commentButton.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    override func configureView() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
}

extension FeedTableViewCell {
    
    func updateView(_ data: PostResponse.FetchPost) {
        //imageView.loadImage(urlString: data.files[0])
        
        nicknameLabel.text = data.creator.nick
        profileImageView.loadImage(urlString: data.creator.profileImage)
        
        titleLabel.text = data.title
        hashTagLabel.text = data.hashTags.description
    }
}
