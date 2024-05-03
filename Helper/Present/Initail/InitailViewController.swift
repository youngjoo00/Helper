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
        LoadingIndicatorManager.shared.showIndicator()
        if UserDefaultsManager.shared.getUserID().isEmpty {
            changeSignInRootView()
        } else {
            changeHomeRootView()
        }
    }

}
