//
//  UIWindow+.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit

extension UIWindow {
    
    var keyWindowInConnectedScenes: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first

        return window
    }
}
