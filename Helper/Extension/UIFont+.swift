//
//  UIFont+.swift
//  Helper
//
//  Created by youngjoo on 5/5/24.
//

import UIKit

extension UIFont {
    static func seolleim(size fontSize: CGFloat) -> UIFont {
        let familyName = "seolleimcoolot-SemiBold"
        
        return UIFont(name: "\(familyName)", size: fontSize) ?? .systemFont(ofSize: fontSize)
    }
}
