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

    let editMenuTap = PublishSubject<Void>()
    let deleteMenuTap = PublishSubject<Void>()
    
    let profileTabGesture = UITapGestureRecognizer()
    lazy var profileStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.addGestureRecognizer(profileTabGesture)
    }
    
    let profileImageView = ProfileImageView()
    let nicknameLabel = PointBoldLabel(fontSize: 18)
    let regDateLabel = PointLabel(fontSize: 15)

    let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true
    }
    
    let imageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.backgroundColor = .purple
    }
        
    let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .black
        $0.pageIndicatorTintColor = .lightGray
        $0.hidesForSinglePage = true
    }
    
    let commentButton = ImageButton(image: UIImage(systemName: "message"))
    let storageButton = ImageButton(image: UIImage(systemName: "bookmark"))
    let titleLabel = PointLabel(fontSize: 16).then {
        $0.numberOfLines = 0
    }
    
    let hashTagLabel = PointLabel(fontSize: 15).then {
        $0.numberOfLines = 0
    }
    
    let editButton = ImageButton(image: UIImage(systemName: "line.3.horizontal"))
    override func configureHierarchy() {
        [
            profileStackView,
            regDateLabel,
            scrollView,
            storageButton,
            commentButton,
            pageControl,
            titleLabel,
            hashTagLabel,
            editButton,
        ].forEach { contentView.addSubview($0) }

        [
            profileImageView,
            nicknameLabel,
        ].forEach { profileStackView.addArrangedSubview($0) }
        
        [
            imageStackView
        ].forEach { scrollView.addSubview($0) }
        
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
        
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileStackView)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-5)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(profileStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerY.equalTo(commentButton)
            make.centerX.equalToSuperview()
        }
        
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(5)
            make.leading.equalTo(safeAreaLayoutGuide).offset(5)
            make.size.equalTo(44)
        }
        
        storageButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(5)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-5)
            make.size.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(commentButton.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        hashTagLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
        }
        
        regDateLabel.snp.makeConstraints { make in
            make.top.equalTo(hashTagLabel.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    override func configureView() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        let subviews = imageStackView.arrangedSubviews
        for subview in subviews {
            // 스택뷰의 배열에서만 제거
            imageStackView.removeArrangedSubview(subview)
            // 실제 화면에 보이는 뷰 제거
            subview.removeFromSuperview()
        }
        
        disposeBag = DisposeBag()
    }
    
}

extension FeedTableViewCell {
    
    func updateView(_ data: PostResponse.FetchPost) {
        configureImageView(data.files)
        nicknameLabel.text = data.creator.nick
        profileImageView.loadImage(urlString: data.creator.profileImage)
        
        titleLabel.text = data.title
        hashTagLabel.text = data.hashTags.description
        pageControl.numberOfPages = data.files.count
        regDateLabel.text = DateManager.shared.dateFormat(data.createdAt)
        let state = data.storage.listCheckedUserID
        storageButton.configureView(image: UIImage(systemName: state ? "bookmark.fill" : "bookmark"))
        
        if data.creator.userID.checkedUserID {
            configureEditButton()
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
        
    }
    
    private func configureImageView(_ files: [String]) {
        files.forEach { file in
            // 이미지뷰를 넣고, 해당 이미지뷰를 로드진행
            let feedImageView = lightGrayBackgroundImageView()
            feedImageView.snp.makeConstraints { make in
                make.size.equalTo(UIScreen.main.bounds.width)
            }
            imageStackView.addArrangedSubview(feedImageView)
            feedImageView.loadImage(urlString: file)
        }
    }
    
    private func configureEditButton() {
        let menuItems = [
            UIAction(title: "수정", image: UIImage(systemName: "pencil")) { [weak self] _ in
                guard let self = self else { return }
                self.editMenuTap.onNext(())
            },
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.deleteMenuTap.onNext(())
            }
        ]
        
        let menu = UIMenu(title: "", children: menuItems)
        editButton.menu = menu
        editButton.showsMenuAsPrimaryAction = true // 버튼 탭 시 메뉴 표시
    }
}
