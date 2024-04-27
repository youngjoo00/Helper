//
//  OtherProfileTabViewController.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Tabman
import Pageboy
import Then

final class OtherProfileTabViewController: TabmanViewController {
    
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

extension OtherProfileTabViewController {

    private func configureView() {
        
        let otherPostVC = OtherPostViewController()
        
        viewControllers.append(contentsOf: [otherPostVC])
        
        dataSource = self
        addBar(bar, dataSource: self, at: .top)
    }
}

extension OtherProfileTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "게시물")
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
