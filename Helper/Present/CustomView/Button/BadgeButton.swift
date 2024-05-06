//
//  BadgeButton.swift
//  Helper
//
//  Created by youngjoo on 5/5/24.
//

//import UIKit
//import Then
//
//final class BadgeButton: UIButton {
//
//    let badgeLabel = UILabel().then {
//        $0.backgroundColor = .red
//        $0.textColor = .white
//        $0.font = UIFont.systemFont(ofSize: 12)
//        $0.textAlignment = .center
//        $0.clipsToBounds = true
//        $0.layer.cornerRadius = 10
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    
//    convenience init(image: UIImage?) {
//        self.init()
//        configureView(image: image)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//
//extension BadgeButton {
//    
//    func configureView(image: UIImage?) {
//        var configuration = UIButton.Configuration.gray()
//        configuration.baseForegroundColor = Color.black
//        configuration.baseBackgroundColor = Color.white
//        configuration.image = image
//        self.configuration = configuration
//        
//        self.addSubview(badgeLabel)
//        
//        badgeLabel.snp.makeConstraints { make in
//            make.top.equalTo(self.snp.top)
//            make.trailing.equalTo(self.snp.trailing)
//            make.width.height.equalTo(20)
//        }
//    }
//    
//    func updateBadgeText(_ count: Int) {
//        badgeLabel.text = count.description
//    }
//}
