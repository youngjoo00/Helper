//
//  PointLabel.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit

class PointLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ text: String? = nil, fontSize: CGFloat) {
        self.init()
        self.text = text
        self.textColor = Color.black
        self.font = .systemFont(ofSize: fontSize)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
