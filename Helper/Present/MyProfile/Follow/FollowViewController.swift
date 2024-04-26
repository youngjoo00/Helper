//
//  FollowViewController.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Then
import SnapKit

final class FollowViewController: BaseViewController {

    private let mainView = FollowView()
    private var tabVC = FollowTabViewController()

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabViewController()
    }
    
    override func configureNavigationBackButton() {
        super.configureNavigationBackButton()
        
        navigationItem.titleView = mainView.navTitle
    }
}

// MARK: - Custom Func
extension FollowViewController {
    
    private func configureTabViewController() {

        addChild(tabVC)
        mainView.containerView.addSubview(tabVC.view)

        tabVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tabVC.didMove(toParent: self)
    }
}
