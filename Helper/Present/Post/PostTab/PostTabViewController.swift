//
//  PostTabViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Tabman
import Pageboy

final class PostTabViewController: TabmanViewController {
    
    let mainView = PostTabView()
    var viewControllers: [UIViewController] = []
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = mainView.navTitle
        configureView()
    }
}

extension PostTabViewController {
    
    private func configureView() {
        let findingVC = FindingViewController()
        let foundVC = FoundViewController()
        
        viewControllers.append(contentsOf: [findingVC, foundVC])
        
        dataSource = self
        addBar(mainView.bar, dataSource: self, at: .custom(view: mainView.tabSpaceView, layout: nil))
    }
}

extension PostTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "찾고있어요")
        case 1:
            return TMBarItem(title: "찾았어요")
        default:
            return TMBarItem(title: "Page \(index)")
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        guard viewControllers.indices.contains(index) else { return nil }
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }
}
