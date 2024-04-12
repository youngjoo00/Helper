//
//  SceneDelegate.swift
//  Helper
//
//  Created by youngjoo on 4/12/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        let vc = SignInViewController()
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
//        let value = UserDefaults.standard.bool(forKey: "userState")
//        
//        if !value {
//            window = UIWindow(windowScene: scene)
//            
//            let SignUp = UINavigationController(rootViewController: SignUpViewController())
//            
//            window?.rootViewController = OnBoarding
//            window?.makeKeyAndVisible()
//        } else {
//            window = UIWindow(windowScene: scene)
//            
//            let tabBar = UITabBarController()
//            let sb = UIStoryboard(name: "Main", bundle: nil)
//            let firstTab = sb.instantiateViewController(withIdentifier: "MainNavigationController")
//            
//            let firstTabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
//            firstTab.tabBarItem = firstTabBarItem
//            
//            let secondTab = UINavigationController(rootViewController: SettingViewController())
//            let secondTabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 1)
//            secondTab.tabBarItem = secondTabBarItem
//            
//            tabBar.viewControllers = [firstTab, secondTab]
//            
//            window?.rootViewController = tabBar
//            window?.makeKeyAndVisible()
//        }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

