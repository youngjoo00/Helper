//
//  MenuButton.swift
//  Helper
//
//  Created by youngjoo on 4/21/24.
//


import UIKit
import Then

class MenuButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(title: String?) {
        self.init()
        configureView(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MenuButton {
    
    func configureView(_ title: String?) {
        var configuration = UIButton.Configuration.gray()
        configuration.baseForegroundColor = Color.black
        configuration.baseBackgroundColor = Color.white
        configuration.title = title
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.imagePadding = 10
        configuration.imagePlacement = .trailing
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = Color.black.cgColor
        layer.cornerRadius = 16
        self.configuration = configuration
    }
    
}
