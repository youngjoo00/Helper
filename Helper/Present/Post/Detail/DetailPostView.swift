//
//  DetailPostView.swift
//  Helper
//
//  Created by youngjoo on 4/18/24.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class DetailPostView: BaseView {

    lazy var commentWriteSubject = BehaviorSubject<String>(value: commentWriteTextField.text ?? "")
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let nicknameLabel = PointBoldLabel(fontSize: 18)
    let regDateLabel = PointLabel(fontSize: 15)
    
    let categoryLabel = PointLabel(fontSize: 20)
    let hashTagLabel = PointBoldLabel(fontSize: 20)
    let storageButton = ImageButton(image: UIImage(systemName: "bookmark"))
    
    let imageCollectionView = BaseCollectionView(frame: .zero, collectionViewLayout: .imageCollectionViewLayout()).then {
        $0.register(DetailPostCollectionViewCell.self, forCellWithReuseIdentifier: DetailPostCollectionViewCell.id)
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    let titleLabel = PointLabel(fontSize: 20)
    
    let featureLabel = PointLabel("특징", fontSize: 17)
    let featureValueLabel = PointLabel(fontSize: 17).then {
        $0.numberOfLines = 0
    }

    let regionLocateLabel = PointLabel("위치", fontSize: 17)
    let regionLocateValueLabel = PointLabel(fontSize: 17).then {
        $0.numberOfLines = 0
    }

    let dateLabel = PointLabel("날짜", fontSize: 17)
    let dateValueLabel = PointLabel(fontSize: 17)
    
    let phoneLabel = PointLabel("연락처", fontSize: 17)
    let phoneValueLabel = PointLabel("연락처", fontSize: 17)
    
    let contentLabel = PointLabel("내용", fontSize: 17)
    let contentValueLabel = PointLabel(fontSize: 17)

    let commentsLabel = PointLabel("0개의 댓글", fontSize: 17)
    let commentsTableView = BaseTableView().then {
        $0.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsTableViewCell.id)
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.isScrollEnabled = false
    }
    
    let commentView = UIView().then {
        $0.backgroundColor = .white
    }
    let commentWriteTextField = PointTextField(placeholderText: "댓글 내용을 입력하세요")
    let commentWriteButton = PointButton(title: "등록")
    
    let scrollBottomSpaceView = UIView()
    
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
            featureLabel,
            featureValueLabel,
            regionLocateLabel,
            regionLocateValueLabel,
            dateLabel,
            dateValueLabel,
            phoneLabel,
            phoneValueLabel,
            contentLabel,
            contentValueLabel,
            commentsLabel,
            commentsTableView,
            scrollBottomSpaceView,
        ].forEach { contentView.addSubview($0) }

        [
            commentWriteTextField,
            commentWriteButton,
        ].forEach { commentView.addSubview($0) }
        
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
            make.trailing.equalTo(safeAreaLayoutGuide)
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
        
        featureLabel.snp.makeConstraints { make in
            make.top.equalTo(featureValueLabel)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(55)
        }
        
        featureValueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(featureLabel.snp.trailing)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        regionLocateLabel.snp.makeConstraints { make in
            make.top.equalTo(regionLocateValueLabel)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(featureLabel)
        }
        
        regionLocateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(featureValueLabel.snp.bottom).offset(10)
            make.leading.equalTo(regionLocateLabel.snp.trailing)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateValueLabel)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(featureLabel)
        }
        
        dateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(regionLocateValueLabel.snp.bottom).offset(10)
            make.leading.equalTo(dateLabel.snp.trailing)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneValueLabel)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(featureLabel)
        }
        
        phoneValueLabel.snp.makeConstraints { make in
            make.top.equalTo(dateValueLabel.snp.bottom).offset(10)
            make.leading.equalTo(phoneLabel.snp.trailing)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(featureLabel)
        }
        
        contentValueLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        commentsLabel.snp.makeConstraints { make in
            make.top.equalTo(contentValueLabel.snp.bottom).offset(15)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        commentsTableView.snp.makeConstraints { make in
            make.top.equalTo(commentsLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(0)
        }
        
        scrollBottomSpaceView.snp.makeConstraints { make in
            make.top.equalTo(commentsTableView.snp.bottom).offset(10)
            make.height.equalTo(66)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        commentView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(66)
        }
        
        commentWriteTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(commentWriteButton.snp.leading).offset(-16)
        }
        
        commentWriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(70)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
    }
    
    override func configureView() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        commentsTableViewHeightUpdate()

    }
    
}

// MARK: - Custom Func
extension DetailPostView {
    
    // 콘텐츠 높이에 맞게 테이블뷰 높이 설정
    func commentsTableViewHeightUpdate() {
        commentsTableView.snp.updateConstraints { make in
            make.height.equalTo(commentsTableView.contentSize.height)
        }
    }
    
    // 콘텐츠 변경 시 높이 재설정
    func performBatcUpdate() {
        // performBatchUpdates 을 사용하여 변경 사항이 존재할때 값을 안넣어버리고, 온전히 변경이 끝났을 때 높이를 변경하도록 함
        commentsTableView.performBatchUpdates(nil) { _ in
            self.commentsTableViewHeightUpdate()
        }
    }
    
    func updateStorageButton(_ state: Bool) {
        storageButton.configureView(image: UIImage(systemName: state ? "bookmark.fill" : "bookmark"))
    }
    
    func updateCommentTextField() {
        commentWriteTextField.text = ""
        commentWriteSubject.onNext("")
    }
}



