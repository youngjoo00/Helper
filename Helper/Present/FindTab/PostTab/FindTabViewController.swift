//
//  PostTabViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Tabman
import Pageboy

enum FindViewMode {
    case finding
    case found
}

final class FindTabViewController: TabmanViewController {
    
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

// MARK: - Custom Func
extension FindTabViewController {
    
    private func configureView() {
        let findingVC = FindViewController(.finding)
        let foundVC = FindViewController(.found)
        
        viewControllers.append(contentsOf: [findingVC, foundVC])
        
        dataSource = self
        addBar(bar, dataSource: self, at: .top)
    }
}

// MARK: - Tabman DataSource
extension FindTabViewController: TMBarDataSource {
    
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
    
}


// MARK: - PageBody
extension FindTabViewController: PageboyViewControllerDataSource {

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
