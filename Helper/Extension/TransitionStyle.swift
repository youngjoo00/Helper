//
//  TransitionStyle.swift
//  Helper
//
//  Created by youngjoo on 4/21/24.
//

import UIKit

enum TransitionStyle {
    case present
    case presentNavigation
    case presentFullnavigation
    case push
    case hideBottomPush
}

extension UIViewController {
    func transition<T: UIViewController>(viewController: T, style: TransitionStyle) {
        
        switch style {
        case .present:
            present(viewController, animated: true)
        case .presentNavigation:
            let nav = UINavigationController(rootViewController: viewController)
            present(nav, animated: true)
        case .presentFullnavigation:
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        case .hideBottomPush:
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
