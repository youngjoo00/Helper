//
//  HomeView.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Then

final class HomeView: BaseView {
    
    let naviTitle = PointBoldLabel("Helper", fontSize: 20)
    let scrollView = UIScrollView()
    let contentView = UIView()
    let scrollBottomSpaceView = UIView()
    
    let recentPostsFollowingTitleLabel = PointBoldLabel("팔로잉 최근 게시물", fontSize: 18)
    let recentPostsFollowingView = HorizontalPostsView(collectionViewCellType: RecentPostsFromFollowingCollectionViewCell.self).then {
        $0.backgroundColor = .gray
    }
    
    let recentPostsFindingTitleLabel = PointBoldLabel("찾고있어요 최근 게시물", fontSize: 18)
    let recentPostsFindingView = HorizontalPostsView(collectionViewCellType: PostCollectionViewCell.self)
    
    let recentPostsFoundTitleLabel = PointBoldLabel("찾았어요 최근 게시물", fontSize: 18)
    let recentPostsFoundView = HorizontalPostsView(collectionViewCellType: PostCollectionViewCell.self)
    
    override func configureHierarchy() {
        [
            scrollView,
        ].forEach { addSubview($0) }

        scrollView.addSubview(contentView)
        
        [
            recentPostsFollowingTitleLabel,
            recentPostsFollowingView,
            recentPostsFindingTitleLabel,
            recentPostsFindingView,
            recentPostsFoundTitleLabel,
            recentPostsFoundView,
            scrollBottomSpaceView,
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        recentPostsFollowingTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        recentPostsFollowingView.snp.makeConstraints { make in
            make.top.equalTo(recentPostsFollowingTitleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width / 3)
        }
        
        recentPostsFindingTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(recentPostsFollowingView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        recentPostsFindingView.snp.makeConstraints { make in
            make.top.equalTo(recentPostsFindingTitleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width / 3 * 1.5)
        }
        
        recentPostsFoundTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(recentPostsFindingView.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        recentPostsFoundView.snp.makeConstraints { make in
            make.top.equalTo(recentPostsFoundTitleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width / 3 * 1.5)
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
