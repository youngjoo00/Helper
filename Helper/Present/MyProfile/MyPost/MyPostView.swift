//
//  MyPostView.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Then

final class MyPostView: BaseView {
    
    lazy var collectionView = BaseCollectionView(frame: .zero, collectionViewLayout: .postCollectionViewLayout()).then {
        $0.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.id)
    }
    
    override func configureHierarchy() {
        [
            collectionView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        
    }
}


// MARK: - Custom Func
extension MyPostView {
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        
        let cellWidth = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        let cellhieght = cellWidth * 1.5
        
        layout.itemSize = CGSize(width: cellWidth, height: cellhieght)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }
   
}
