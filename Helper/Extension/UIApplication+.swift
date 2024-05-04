//
//  UIApplication.swift
//  Helper
//
//  Created by youngjoo on 5/4/24.
//

import UIKit

extension UIApplication {
    // keyWindow 가져오기
    var getWindow: UIWindow? {
        connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }
    }
}
