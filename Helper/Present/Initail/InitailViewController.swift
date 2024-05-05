//
//  InitailViewController.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class InitailViewController: BaseViewController {

    private let mainView = InitailView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainPoint
        nextTransition()
    }
    
    override func handleNetworkReconnection(_ notification: Notification) {
        super.handleNetworkReconnection(notification)
        
        nextTransition()
    }

}

extension InitailViewController {
    
    private func nextTransition() {
        LoadingIndicatorManager.shared.showIndicator()
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            if UserDefaultsManager.shared.getUserID().isEmpty {
                self.changeSignInRootView()
            } else {
                self.changeHomeRootView()
            }
        }
    }
}
