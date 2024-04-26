//
//  PointBoldLabel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit

class PointBoldLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ text: String? = nil, fontSize: CGFloat, alignment: NSTextAlignment = .natural) {
        self.init()
        self.text = text
        self.textColor = Color.black
        self.font = .boldSystemFont(ofSize: fontSize)
        self.textAlignment = alignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
