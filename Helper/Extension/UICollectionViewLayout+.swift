//
//  UICollectionViewLayout+.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit

extension UICollectionViewLayout {
    static func postCollectionViewLayout() -> UICollectionViewLayout {
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
