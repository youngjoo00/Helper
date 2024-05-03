//
//  SeparatorView.swift
//  Helper
//
//  Created by youngjoo on 5/2/24.
//

import UIKit
import Then

final class SeparatorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SeparatorView {
    
    func configureView() {
        backgroundColor = .lightGray
    }
    
}
