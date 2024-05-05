//
//  BaseViewController.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/28/24.
//

import UIKit
import RxSwift
import Toast
import Then

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("baseVC")
        view.backgroundColor = .white
        configureNavigationBackButton()
        bind()
    }
    
    func configureNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginSessionExpired), name: .loginSessionExpired, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginSessionExpired), name: .unknownError, object: nil)
    }
    
    @objc func handleLoginSessionExpired(_ notification: Notification) {
        showAlert(title: "안내", message: "로그인 세션이 만료되었습니다. 다시 로그인해 주세요.") {
            self.changeSignInRootView()
        }
    }
    
    @objc func handleUnknownError(_ notification: Notification) {
        showAlert(title: "안내", message: "알 수 없는 오류로 인해 로그인 화면으로 이동합니다.") {
            self.changeSignInRootView()
        }
    }
    
    
    func showTaost(_ message: String) {
        view.makeToast(message, duration: 1.5, position: .center)
    }
    
    func bind() { }
    
    func configureNavigationBackButton() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        self.navigationController?.navigationBar.tintColor = Color.black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func configureLogo() {
        let leftItem = UIBarButtonItem(customView: HelperLabel("Helper", fontSize: 30))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
