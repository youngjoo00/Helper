//
//  ProfileImageView.swift
//  Helper
//
//  Created by youngjoo on 4/26/24.
//

import UIKit

final class ProfileImageView: UIImageView {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
}

extension ProfileImageView {
    
    private func configureView() {
        backgroundColor = .lightGray
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    func updateImage(_ urlString: String) {
        self.loadImage(urlString: urlString)
    }
}
