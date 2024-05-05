//
//  HomeView.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Then

final class HomeView: BaseView {
    
    let naviTitle = HelperLabel("Helper", fontSize: 30)
    
    let refreshControl = UIRefreshControl()
    lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.refreshControl = refreshControl
    }
    let contentView = UIView()
    let scrollBottomSpaceView = UIView()
    
    let postsStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    let recentPostsFollowingTitleLabel = HelperLabel("팔로잉 최근 게시물", fontSize: 25, color: UIColor.black)
    let recentPostsFollowingView = HorizontalPostsView(collectionViewCellType: RecentPostsFromFollowingCollectionViewCell.self)
    
    let recentPostsFindingTitleLabel = HelperLabel("찾고있어요 최근 게시물", fontSize: 25, color: UIColor.black)
    let recentPostsFindingView = HorizontalPostsView(collectionViewCellType: PostCollectionViewCell.self)
    
    let recentPostsFoundTitleLabel = HelperLabel("찾았어요 최근 게시물", fontSize: 25, color: UIColor.black)
    let recentPostsFoundView = HorizontalPostsView(collectionViewCellType: PostCollectionViewCell.self)
    
    override func configureHierarchy() {
        [
            scrollView,
        ].forEach { addSubview($0) }

        scrollView.addSubview(contentView)
        
        [
            postsStackView,
            scrollBottomSpaceView,
        ].forEach { contentView.addSubview($0) }
        
        [
            recentPostsFollowingTitleLabel,
            recentPostsFollowingView,
            recentPostsFindingTitleLabel,
            recentPostsFindingView,
            recentPostsFoundTitleLabel,
            recentPostsFoundView,
        ].forEach { postsStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        postsStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(scrollBottomSpaceView)
        }
        
        recentPostsFollowingTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        recentPostsFollowingView.snp.makeConstraints { make in
            make.top.equalTo(recentPostsFollowingTitleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width / 3 * 1.5)
        }
        
        recentPostsFindingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(recentPostsFollowingView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        recentPostsFindingView.snp.makeConstraints { make in
            make.top.equalTo(recentPostsFindingTitleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width / 3 * 1.8)
        }
        
        recentPostsFoundTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(recentPostsFindingView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        recentPostsFoundView.snp.makeConstraints { make in
            make.top.equalTo(recentPostsFoundTitleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width / 3 * 1.8)
        }
        
        scrollBottomSpaceView.snp.makeConstraints { make in
            make.top.equalTo(recentPostsFoundView.snp.bottom).offset(10)
            make.height.equalTo(66)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
    }
}
