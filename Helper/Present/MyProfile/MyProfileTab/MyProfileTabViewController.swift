//
//  MyProfileTabViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Tabman
import Pageboy
import Then

final class MyProfileTabViewController: TabmanViewController {
    
    var viewControllers: [UIViewController] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        view.backgroundColor = .white
    }
    
}

extension MyProfileTabViewController {

    private func configureView() {
        let myPostVC = MyPostViewController()
        let myStorageVC = MyStoragePostViewController()
        
        viewControllers.append(contentsOf: [myPostVC, myStorageVC])
        
        dataSource = self
        addBar(bar, dataSource: self, at: .top)
    }
}

extension MyProfileTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "작성한 게시글")
        case 1:
            return TMBarItem(title: "저장한 게시글")
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
