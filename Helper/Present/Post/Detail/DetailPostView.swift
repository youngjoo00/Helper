//
//  DetailPostView.swift
//  Helper
//
//  Created by youngjoo on 4/18/24.
//

import UIKit
import Then

final class DetailPostView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let nicknameLabel = PointBoldLabel(fontSize: 18)
    let regDateLabel = PointLabel(fontSize: 15)
    
    let categoryLabel = PointLabel(fontSize: 20)
    let hashTagLabel = PointBoldLabel(fontSize: 20)
    let storageButton = WhiteButton(title: nil, image: UIImage(systemName: "bookmark"))
    
    let imageCollectionView = BaseCollectionView(frame: .zero, collectionViewLayout: .imageCollectionViewLayout()).then {
        $0.register(DetailPostCollectionViewCell.self, forCellWithReuseIdentifier: DetailPostCollectionViewCell.id)
        $0.showsVerticalScrollIndicator = false
    }

    let contentsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    let titleLabel = PointLabel(fontSize: 20)
    
    let featureStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    let featureLabel = PointLabel("특징", fontSize: 17)
    let featureValueLabel = PointLabel(fontSize: 17).then {
        $0.numberOfLines = 2
    }
    
    let regionLocateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    let regionLocateLabel = PointLabel("위치", fontSize: 17)
    let regionValueLabel = PointLabel(fontSize: 17)
    let locateValueeLabel = PointLabel("", fontSize: 17).then {
        $0.numberOfLines = 2
    }
    
    let dateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    let dateLabel = PointLabel("날짜", fontSize: 17)
    let dateValueLabel = PointLabel(fontSize: 17)
    
    let phoneStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    let phoneLabel = PointLabel("연락처", fontSize: 17)
    let phoneValueLabel = PointLabel("연락처", fontSize: 17)
    
    let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 10
    }
    let contentLabel = PointLabel("내용", fontSize: 17)
    let contentValueLabel = PointLabel(fontSize: 17)

    let commentsLabel = PointLabel("0개의 댓글", fontSize: 17)
    let commentsTableView = BaseTableView().then {
        $0.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsTableViewCell.id)
    }
    
    let commentView = UIView()
    let commentTextField = PointTextField(placeholderText: "댓글 내용을 입력하세요")
    let commentWriteButton = PointButton(title: "등록")
    
    override func configureHierarchy() {
        [
            scrollView,
            commentView,
        ].forEach { addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [
            nicknameLabel,
            regDateLabel,
            categoryLabel,
            hashTagLabel,
            storageButton,
            imageCollectionView,
            titleLabel,
            contentsStackView,
            commentsLabel,
            commentsTableView,
        ].forEach { contentView.addSubview($0) }
        
        [
            featureStackView,
            regionLocateStackView,
            dateStackView,
            phoneStackView,
            contentStackView,
        ].forEach { contentsStackView.addArrangedSubview($0) }
        
        [
            featureLabel,
            featureValueLabel
        ].forEach { featureStackView.addArrangedSubview($0) }

        [
            regionLocateLabel,
            regionValueLabel,
            locateValueeLabel
        ].forEach { regionLocateStackView.addArrangedSubview($0) }
        
        [
            dateLabel,
            dateValueLabel
        ].forEach { dateStackView.addArrangedSubview($0) }

        [
            phoneLabel,
            phoneValueLabel
        ].forEach { phoneStackView.addArrangedSubview($0) }

        [
            contentLabel,
            contentValueLabel
        ].forEach { contentStackView.addArrangedSubview($0) }
        
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        regDateLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel)
            make.leading.equalTo(categoryLabel.snp.trailing).offset(10)
        }
        
        storageButton.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel).offset(-5)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        contentsStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        commentsLabel.snp.makeConstraints { make in
            make.top.equalTo(contentsStackView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        commentsTableView.snp.makeConstraints { make in
            make.top.equalTo(commentsLabel.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}