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

final class DetailFindView: BaseView {

    // MARK: - titleView
    let titleView = UIView()
    let chatButton = ImageButton(image: UIImage(systemName: "plus.message"))
    
    // MARK: - mainView
    lazy var commentWriteSubject = BehaviorSubject<String>(value: commentWriteTextView.text ?? "")
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let profileTabGesture = UITapGestureRecognizer()
    lazy var profileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.addGestureRecognizer(profileTabGesture)
    }
    
    let profileImageView = ProfileImageView()
    let nicknameLabel = PointBoldLabel(fontSize: 18)
    let regDateLabel = PointLabel(fontSize: 15)
    
    let categoryLabel = PointLabel(fontSize: 16)
    let hashTagLabel = PointLabel(fontSize: 16)
    let storageButton = ImageButton(image: UIImage(systemName: "bookmark"))
    let completeButton = CompleteButton()
    
    let imageCollectionView = BaseCollectionView(frame: .zero, collectionViewLayout: .imageCollectionViewLayout()).then {
        $0.register(DetailFindCollectionViewCell.self, forCellWithReuseIdentifier: DetailFindCollectionViewCell.id)
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .black
        $0.pageIndicatorTintColor = .lightGray
    }
    
    let titleLabel = PointBoldLabel(fontSize: 20)
    
    let infoTopSeparatorView = SeparatorView()
    
    let featureLabel = PointBoldLabel("특징", fontSize: 17)
    let featureValueLabel = PointLabel(fontSize: 17).then {
        $0.numberOfLines = 0
    }

    let regionLocateLabel = PointBoldLabel("위치", fontSize: 17)
    let regionLocateValueLabel = PointLabel(fontSize: 17).then {
        $0.numberOfLines = 0
    }

    let dateLabel = PointBoldLabel("날짜", fontSize: 17)
    let dateValueLabel = PointLabel(fontSize: 17)
    
    let phoneLabel = PointBoldLabel("연락처", fontSize: 17)
    let phoneValueLabel = PointLabel(fontSize: 17)
        
    let contentLabel = PointBoldLabel("상세내용", fontSize: 17)
    let contentValueLabel = PointLabel(fontSize: 17).then {
        $0.numberOfLines = 0
    }
    
    let contentBottomSeparatorView = SeparatorView()

    let commentsLabel = PointBoldLabel(fontSize: 17)
    let commentsTableView = BaseTableView().then {
        $0.register(CommentsTableViewCell.self, forCellReuseIdentifier: CommentsTableViewCell.id)
        $0.estimatedRowHeight = 44
        $0.rowHeight = UITableView.automaticDimension
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    let commentView = UIView().then {
        $0.backgroundColor = .white
    }
    let commentWriteTextView = CommentTextView()
    let commentWriteButton = PointButton(title: "등록")
    
    let scrollBottomSpaceView = UIView()
    
    override func configureHierarchy() {
        titleView.addSubview(chatButton)
        
        [
            scrollView,
            commentView,
        ].forEach { addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        [
            profileStackView,
            regDateLabel,
            categoryLabel,
            hashTagLabel,
            storageButton,
            completeButton,
            imageCollectionView,
            pageControl,
            titleLabel,
            infoTopSeparatorView,
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
            contentBottomSeparatorView,
            commentsLabel,
            commentsTableView,
            scrollBottomSpaceView,
        ].forEach { contentView.addSubview($0) }

        [
            profileImageView,
            nicknameLabel,
        ].forEach { profileStackView.addArrangedSubview($0) }
        
        [
            commentWriteTextView,
            commentWriteButton,
        ].forEach { commentView.addSubview($0) }
        
    }
    
    override func configureLayout() {
        
        titleView.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        chatButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
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
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel)
            make.leading.equalTo(categoryLabel.snp.trailing).offset(10)
        }
        
        storageButton.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel).offset(-8)
            make.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerY.equalTo(hashTagLabel).offset(-1)
            make.leading.equalTo(hashTagLabel.snp.trailing).offset(15)
            make.height.equalTo(30)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        infoTopSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        featureLabel.snp.makeConstraints { make in
            make.top.equalTo(featureValueLabel)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.width.equalTo(55)
        }
        
        featureValueLabel.snp.makeConstraints { make in
            make.top.equalTo(infoTopSeparatorView.snp.bottom).offset(10)
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
            make.top.equalTo(phoneValueLabel.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        contentValueLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        contentBottomSeparatorView.snp.makeConstraints { make in
            make.top.equalTo(contentValueLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        commentsLabel.snp.makeConstraints { make in
            make.top.equalTo(contentBottomSeparatorView.snp.bottom).offset(15)
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
            make.height.equalTo(commentWriteTextView.snp.height).offset(20)
        }
        
        commentWriteTextView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(commentWriteButton.snp.leading).offset(-16)
        }
        
        commentWriteButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
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
extension DetailFindView {
    
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
    
    func updateCompleteButton(_ state: Bool) {
        completeButton.configureView(state)
    }
    
    func updateCommentTextField() {
        commentWriteTextView.text = ""
        commentWriteSubject.onNext("")
    }
    
    func titleLabelLayoutUpdate() {
        titleLabel.snp.remakeConstraints { make in
            if pageControl.isHidden {
                make.top.equalTo(imageCollectionView.snp.bottom).offset(10)
            } else {
                make.top.equalTo(pageControl.snp.bottom)
            }
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }

    func adjustTextViewHeight() {
        let maxHeight: CGFloat = 100.0
        
        // sizeThatFits를 사용하여 실제 필요한 높이 계산
        let fittingSize = commentWriteTextView.sizeThatFits(CGSize(width: commentWriteTextView.bounds.width, height: CGFloat.infinity))
        let currentHeight = max(44.0, fittingSize.height)
        
        if currentHeight <= maxHeight {
            // 최대 높이 이하일 경우
            commentWriteTextView.snp.updateConstraints { make in
                make.height.equalTo(currentHeight)
            }
            commentWriteTextView.isScrollEnabled = false // 스크롤 비활성화
        } else {
            // 최대 높이를 초과할 경우
            commentWriteTextView.snp.updateConstraints { make in
                make.height.equalTo(maxHeight)
            }
            commentWriteTextView.isScrollEnabled = true // 스크롤 활성화
        }
        
        commentWriteTextView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        // 레이아웃 업데이트
        self.layoutIfNeeded()
    }
}



