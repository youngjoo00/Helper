//
//  PointButton.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//

import UIKit
import Then

class PointButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(title: String, image: UIImage? = nil) {
        self.init()
        configureView(title, image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PointButton {
    
    func configureView(_ title: String, image: UIImage?) {
        var configuration = UIButton.Configuration.gray()
        configuration.baseForegroundColor = Color.white
        configuration.baseBackgroundColor = Color.black
        configuration.title = title
        configuration.image = image
        configuration.imagePadding = 10
        clipsToBounds = true
        layer.cornerRadius = 16
        self.configuration = configuration
    }
    
}
