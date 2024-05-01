//
//  FollowViewController.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Then

/** 
 팔로우 화면전환 모드
 - userID: 연관 값으로 사용하며, userID 연산 프로퍼티로 값 추출 가능
 - modeIndex: follower 0번, follwing 1번
 */
enum FollowViewMode {
    case follower(userID: String)
    case following(userID: String)
    
    var modeIndex: Int {
        switch self {
        case .follower: return 0
        case .following: return 1
        }
    }
    
    var userID: String {
        switch self {
        case .follower(let userID), .following(let userID):
            return userID
        }
    }
}

final class FollowContainerViewController: BaseViewController {

    private let mainView = FollowContainerView()
    private var tabVC: FollowTabViewController
    
    init(_ viewMode: FollowViewMode) {
        tabVC = FollowTabViewController(viewMode: viewMode)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
extension FollowContainerViewController {
    
    private func configureTabViewController() {

        addChild(tabVC)
        mainView.containerView.addSubview(tabVC.view)

        tabVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tabVC.didMove(toParent: self)
    }
}
