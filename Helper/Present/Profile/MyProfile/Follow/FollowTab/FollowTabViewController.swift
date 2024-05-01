//
//  FollowTabViewController.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Tabman
import Pageboy

final class FollowTabViewController: TabmanViewController {
    
    var viewControllers: [UIViewController] = []
    var viewMode: FollowViewMode
    
    let bar = TMBar.ButtonBar().then {
        $0.backgroundView.style = .blur(style: .regular)
        $0.layout.contentInset = UIEdgeInsets.zero
        $0.buttons.customize { (button) in
            button.tintColor = .lightGray
            button.selectedTintColor = Color.black
        }
        $0.indicator.weight = .light
        $0.indicator.tintColor = Color.black
        $0.indicator.overscrollBehavior = .compress
        $0.layout.alignment = .centerDistributed
        $0.layout.contentMode = .fit
        $0.layout.interButtonSpacing = 0
        $0.layout.transitionStyle = .snap
    }
    
    init(viewMode: FollowViewMode) {
        self.viewMode = viewMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        view.backgroundColor = .white
    }
}

// MARK: - Custom Func
extension FollowTabViewController {
    
    private func configureView() {
        
        let followerVC = FollowerViewController(userID: viewMode.userID)
        let followingVC = FollowingViewController()
        
        viewControllers.append(contentsOf: [followerVC, followingVC])
        
        dataSource = self
        addBar(bar, dataSource: self, at: .top)
    }
}

// MARK: - Tabman DataSource
extension FollowTabViewController: TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "팔로워")
        case 1:
            return TMBarItem(title: "팔로잉")
        default:
            return TMBarItem(title: "Page \(index)")
        }
    }
    
}


// MARK: - PageBody
extension FollowTabViewController: PageboyViewControllerDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        guard viewControllers.indices.contains(index) else { return nil }
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: viewMode.modeIndex)
    }
}
