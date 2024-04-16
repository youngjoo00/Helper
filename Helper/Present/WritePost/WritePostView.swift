//
//  WIrtePostView.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit
import Then

final class WritePostView: BaseView {
    
    let imageView = UIImageView()
    
    override func configureHierarchy() {
        [
            imageView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.size.equalTo(200)
        }
    }
    
    override func configureView() {
        
    }
}
