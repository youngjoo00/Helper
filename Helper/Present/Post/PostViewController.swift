//
//  PostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Then
import SnapKit

final class PostViewController: BaseViewController {

    private let mainView = PostView()
    private var tabVC = PostTabViewController()

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabViewController()
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        
        navigationItem.titleView = mainView.navTitle
    }
}

// MARK: - Custom Func
extension PostViewController {
    
    private func configureTabViewController() {

        addChild(tabVC)
        mainView.containerView.addSubview(tabVC.view)

        tabVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tabVC.didMove(toParent: self)
    }
}
