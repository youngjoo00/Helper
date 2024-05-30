//
//  ImageButton.swift
//  Helper
//
//  Created by youngjoo on 4/19/24.
//

import UIKit
import Then

final class ImageButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    convenience init(image: UIImage?) {
        self.init()
        configureView(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageButton {
    
    func configureView(image: UIImage?) {
        var configuration = UIButton.Configuration.gray()
        configuration.baseForegroundColor = Color.black
        configuration.baseBackgroundColor = Color.white
        configuration.image = image
        self.configuration = configuration
    }
}
