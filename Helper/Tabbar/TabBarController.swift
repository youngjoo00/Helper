//
//  TabBarController.swift
//  Helper
//
//  Created by youngjoo on 4/12/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstTab = UINavigationController(rootViewController: PostViewController())
        let firstTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
        firstTab.tabBarItem = firstTabBarItem
        
//        let secondTab = UINavigationController(rootViewController: SearchViewController())
//        let secondTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), tag: 1)
//        
//        if let image = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)) {
//            secondTabBarItem.image = image.imageWithoutBaseline()
//        }
//        secondTab.tabBarItem = secondTabBarItem
//        
//        let thirdTab = UINavigationController(rootViewController: StatsTabViewController())
//        let thirdTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "chart.bar"), tag: 2)
//        if let image = UIImage(systemName: "chart.bar", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)) {
//            thirdTabBarItem.image = image.imageWithoutBaseline()
//        }
//        thirdTab.tabBarItem = thirdTabBarItem
        
        //self.viewControllers = [firstTab, secondTab, thirdTab, forthTab]
        self.viewControllers = [firstTab]
    }
}
