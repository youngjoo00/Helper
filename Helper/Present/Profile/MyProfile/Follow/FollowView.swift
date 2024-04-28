//
//  FollowView.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Tabman
import Then

final class FollowView: BaseView {
    
    let navTitle = PointBoldLabel("팔로우", fontSize: 20)
    let containerView = UIView()
    
    override func configureHierarchy() {
        [
            containerView,
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
    }
}
