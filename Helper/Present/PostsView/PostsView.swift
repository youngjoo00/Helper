//
//  PostsView.swift
//  Helper
//
//  Created by youngjoo on 4/24/24.
//

import UIKit
import Then

final class PostsView: BaseView {
    
    let refreshControl = UIRefreshControl()
    
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
    }
    
    lazy var collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: .postCollectionViewLayout()).then {
        $0.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.id)
        $0.refreshControl = refreshControl
    }
    
    override func configureHierarchy() {
        [
            collectionView,
            activityIndicator
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-10)
            make.centerX.equalToSuperview()
        }
    }
    
    override func configureView() {
    }
    
}
