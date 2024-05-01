//
//  PointTextView.swift
//  Helper
//
//  Created by youngjoo on 4/17/24.
//

import UIKit

final class PointTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        textColor = Color.black
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = Color.black.cgColor
        self.textContainer.lineFragmentPadding = 10
        font = .systemFont(ofSize: 15)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
