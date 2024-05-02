//
//  HorizontalPostsView.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Then

final class HorizontalPostsView: BaseView {
    
    var collectionViewCellType: BaseCollectionViewCell.Type
    
    let refreshControl = UIRefreshControl()
    
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.hidesWhenStopped = true
    }
    
    lazy var collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: .horizontalCollectionViewLayout()).then {
        $0.register(collectionViewCellType.self, forCellWithReuseIdentifier: collectionViewCellType.id)
        $0.showsHorizontalScrollIndicator = false
    }
    
    init(collectionViewCellType: BaseCollectionViewCell.Type) {
        self.collectionViewCellType = collectionViewCellType
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureView() {
    }
    
}
