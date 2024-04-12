//
//  BookImageView.swift
//  ReadingHaracoon
//
//  Created by youngjoo on 3/12/24.
//

import UIKit

final class shadowImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension shadowImageView {
    
    func configureView() {
        contentMode = .scaleAspectFit
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        backgroundColor = .clear
    }
}
