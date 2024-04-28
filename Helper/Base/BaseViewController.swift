//
//  BaseViewController.swift
//  SeSACRxThreads
//
//  Created by youngjoo on 3/28/24.
//

import UIKit
import RxSwift
import Toast

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        bind()
        configureNavigationBackButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginSessionExpired), name: .loginSessionExpired, object: nil)
    }
    
    @objc func handleLoginSessionExpired(_ notification: Notification) {
        showAlert(title: "안내", message: "로그인 세션이 만료되었습니다. 다시 로그인해 주세요.") {
            self.changeSignInRootView()
        }
    }

    func showTaost(_ message: String) {
        view.makeToast(message, duration: 1.5, position: .center)
    }
    
    func bind() { }
    
    func configureNavigationBackButton() {
        // 백버튼 처리
        self.navigationController?.navigationBar.tintColor = Color.black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
