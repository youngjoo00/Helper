//
//  InitailView.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import Then

final class InitailView: BaseView {
    
    let titleLabel = HelperLabel("Helper", fontSize: 80, color: UIColor.white)
    
    override func configureHierarchy() {
        [
            titleLabel,
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
    }
}
