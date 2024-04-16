//
//  TabBarController.swift
//  Helper
//
//  Created by youngjoo on 4/12/24.
//

import UIKit
import PhotosUI

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().unselectedItemTintColor = .systemGray2
        
        let firstTab = UINavigationController(rootViewController: PostViewController())
        firstTab.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        
        let secondTab = UINavigationController(rootViewController: SearchViewController())
        secondTab.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        let thirdTab = UINavigationController(rootViewController: UIViewController())
        thirdTab.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.circle.fill"), tag: 2)
        
        let fourTab = UINavigationController(rootViewController: MyProfileViewController())
        fourTab.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person"), tag: 3)
        
        self.viewControllers = [firstTab, secondTab, thirdTab, fourTab]
    }
}


// MARK: - Tabbar Delegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 3
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            return false
        }
        return true
    }
}


// MARK: - PHPicker Delegate
extension TabBarController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) {
            // 이미지를 저장할 빈 배열을 생성합니다.
            var images: [UIImage] = []
            
            // 결과가 비어있는지 확인
            guard !results.isEmpty else { return }
            
            // 모든 결과에 대해 반복 처리합니다.
            for result in results {
                let itemProvider = result.itemProvider
                
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                        guard let self else { return }
                        if let image = image as? UIImage {
                            images.append(image)
                            
                            DispatchQueue.main.async {
                                if images.count == results.count {
                                    let writePostVC = WritePostViewController()
                                    writePostVC.selectedImages = images
                                    
                                    // 이게 왜 안되는거지?
                                    //self.navigationController?.pushViewController(writePostVC, animated: true)
                                    if let navController = self.selectedViewController as? UINavigationController {
                                        navController.pushViewController(writePostVC, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            
        }
    }
}

