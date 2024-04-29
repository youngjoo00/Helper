//
//  PointBackgroundLabel.swift
//  Helper
//
//  Created by youngjoo on 4/29/24.
//

import UIKit

class PointBackgroundLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
   
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ text: String? = nil, fontSize: CGFloat, alignment: NSTextAlignment = .natural) {
        self.init()
        self.text = text
        self.textColor = Color.white
        self.backgroundColor = Color.point
        self.font = .systemFont(ofSize: fontSize)
        self.textAlignment = alignment
        setupRoundedCorners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
    
    func setupRoundedCorners() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.layer.maskedCorners = [.layerMaxXMaxYCorner] // 오른쪽 하단 모서리만 둥글게
    }
}
