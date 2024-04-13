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
        
        UITabBar.appearance().backgroundColor = Color.white
        UITabBar.appearance().tintColor = Color.black
        UITabBar.appearance().unselectedItemTintColor = .systemGray2
        
        let firstTab = UINavigationController(rootViewController: PostViewController())
        let firstTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        firstTab.tabBarItem = firstTabBarItem
        
        let secondTab = UINavigationController(rootViewController: SearchViewController())
        let secondTabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        secondTab.tabBarItem = secondTabBarItem

        let thirdTab = UINavigationController(rootViewController: MyProfileViewController())
        let thirdTabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person"), tag: 2)
        thirdTab.tabBarItem = thirdTabBarItem
        
        self.viewControllers = [firstTab, secondTab, thirdTab]
    }
}
