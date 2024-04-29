//
//  DetailFeedView.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import Then
import RxSwift

final class DetailFeedView: BaseView {

    lazy var commentWriteSubject = BehaviorSubject<String>(value: commentWriteTextField.text ?? "")
    
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
    
    let storageButton = ImageButton(image: UIImage(systemName: "bookmark"))
    
    let imageCollectionView = BaseCollectionView(frame: .zero, collectionViewLayout: .imageCollectionViewLayout()).then {
        $0.register(DetailPostCollectionViewCell.self, forCellWithReuseIdentifier: DetailPostCollectionViewCell.id)
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .black
        $0.pageIndicatorTintColor = .lightGray
    }
    
    let titleLabel = PointLabel(fontSize: 20)
    let hashTagLabel = PointLabel(fontSize: 16)
    
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
            profileStackView,
            regDateLabel,
            hashTagLabel,
            storageButton,
            imageCollectionView,
            pageControl,
            titleLabel,
            commentsLabel,
            commentsTableView,
            scrollBottomSpaceView,
        ].forEach { contentView.addSubview($0) }

        [
            profileImageView,
            nicknameLabel,
        ].forEach { profileStackView.addArrangedSubview($0) }
        
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
        
        profileStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
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
            make.top.equalTo(profileStackView)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-16)
        }
        
        storageButton.snp.makeConstraints { make in
            make.top.equalTo(regDateLabel.snp.bottom).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-3)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(storageButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        commentsLabel.snp.makeConstraints { make in
            make.top.equalTo(hashTagLabel.snp.bottom).offset(15)
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
        
        //commentsTableViewHeightUpdate()
        
        UIView.performWithoutAnimation {
                commentsTableViewHeightUpdate()
                self.layoutIfNeeded() // 필요한 경우
            }
    }
    
}

// MARK: - Custom Func
extension DetailFeedView {
    
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

}
