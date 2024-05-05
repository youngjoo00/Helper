//
//  BoldTextButton.swift
//  Helper
//
//  Created by youngjoo on 5/5/24.
//

import UIKit
import Then

final class BoldTextPointButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(title: String, size: CGFloat) {
        self.init()
        configureView(title, size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BoldTextPointButton {
    
    func configureView(_ title: String, size: CGFloat) {
        var configuration = UIButton.Configuration.gray()
        configuration.baseForegroundColor = Color.white
        configuration.baseBackgroundColor = Color.point
        let titleFont = UIFont.boldSystemFont(ofSize: size)
        let titleAttributedString = NSAttributedString(
            string: title,
            attributes: [ .font: titleFont])
        configuration.attributedTitle = AttributedString(titleAttributedString)
        clipsToBounds = true
        layer.cornerRadius = 16
        self.configuration = configuration
    }
    
}
