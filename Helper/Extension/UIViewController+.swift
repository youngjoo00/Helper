//
//  UIViewController+Ex.swift
//  LSLPBasic
//
//  Created by jack on 2024/04/09.
//

import UIKit
import RxSwift
import RxCocoa


extension UIViewController {
    func changeHomeRootView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let tabbar = TabBarController()
        sceneDelegate?.window?.rootViewController = tabbar
        sceneDelegate?.window?.makeKey()
    }
    
    func changeSignInRootView() {
        UserDefaultsManager.shared.saveTokens("", refreshToken: "")
        UserDefaultsManager.shared.saveUserID("")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let nav = UINavigationController(rootViewController: SignInViewController())
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKey()
    }

    func showAlert(title: String?, message: String?, btnTitle: String, complectionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: btnTitle, style: .default) { _ in
            complectionHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func showAlert(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    /// 메세지와 확인버튼, completion 메서드
    func showAlert(title: String?, message: String?, complectionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .cancel) { _ in
            complectionHandler()
        }
        
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}


// MARK: - Rx
extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
}


