//
//  FollowButton.swift
//  Helper
//
//  Created by youngjoo on 5/1/24.
//

import UIKit
import Then

final class FollowButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(isFollow: Bool) {
        self.init()
        configureView(isFollow)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FollowButton {
    
    func configureView(_ isFollow: Bool) {
        var configuration = UIButton.Configuration.gray()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .default)
        configuration.baseForegroundColor = Color.white
        configuration.baseBackgroundColor = Color.point
        let titleText = isFollow ? "팔로잉" : "팔로우"
        let titleFont = UIFont.boldSystemFont(ofSize: 15)
        let titleAttributedString = NSAttributedString(
            string: titleText,
            attributes: [ .font: titleFont])
        configuration.attributedTitle = AttributedString(titleAttributedString)
        configuration.image = isFollow ? UIImage(systemName: "checkmark", withConfiguration: symbolConfiguration) : nil
        configuration.imagePadding = 5
        configuration.imagePlacement = .trailing
        clipsToBounds = true
        layer.cornerRadius = 16
        self.configuration = configuration
    }
    
}
