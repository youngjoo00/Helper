//
//  MyProfileViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Then
import SnapKit

final class MyProfileViewController: BaseViewController {

    private let mainView = MyProfileView()
    private var tabVC = MyProfileTabViewController()

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabViewController()
    }
    
    private func configureTabViewController() {
        // 1.
        addChild(tabVC)
        
        // 2.
        mainView.containerView.addSubview(tabVC.view)
        
        // 3.
        tabVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 4.
        tabVC.didMove(toParent: self)
    }
}


