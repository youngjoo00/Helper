//
//  BaseView.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/28/24.
//

import UIKit
import SnapKit
import Then

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() { }
}
