//
//  HelperLabel.swift
//  Helper
//
//  Created by youngjoo on 5/5/24.
//

import UIKit

final class HelperLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ text: String? = nil, fontSize: CGFloat, alignment: NSTextAlignment = .natural, color: UIColor = Color.point) {
        self.init()
        self.text = text
        self.textColor = color
        self.font = .seolleim(size: fontSize)
        self.textAlignment = alignment
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
