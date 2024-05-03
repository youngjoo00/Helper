//
//  BookImageView.swift
//  ReadingHaracoon
//
//  Created by youngjoo on 3/12/24.
//

import UIKit

final class lightGrayBackgroundImageView: UIImageView {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension lightGrayBackgroundImageView {
    
    func configureView() {
        backgroundColor = .lightGray
    }
}
