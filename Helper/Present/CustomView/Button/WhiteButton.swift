//
//  WhiteButton.swift
//  Helper
//
//  Created by youngjoo on 4/17/24.
//

import UIKit
import Then

final class WhiteButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(title: String?, image: UIImage? = nil) {
        self.init()
        configureView(title, image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension WhiteButton {
    
    func configureView(_ title: String?, image: UIImage?) {
        var configuration = UIButton.Configuration.gray()
        configuration.baseForegroundColor = Color.black
        configuration.baseBackgroundColor = Color.white
        configuration.title = title
        configuration.image = image
        configuration.imagePadding = 10
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = Color.black.cgColor
        layer.cornerRadius = 16
        self.configuration = configuration
    }
    
}
