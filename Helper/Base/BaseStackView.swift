//
//  BaseStackView.swift
//  Helper
//
//  Created by youngjoo on 4/30/24.
//

import UIKit
import SnapKit
import Then

class BaseStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
}
