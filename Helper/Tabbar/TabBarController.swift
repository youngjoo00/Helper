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
        
        let homeTab = UINavigationController(rootViewController: HomeViewController())
        homeTab.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        
        let helpTab = UINavigationController(rootViewController: PostViewController())
        helpTab.tabBarItem = UITabBarItem(title: "Help", image: UIImage(systemName: "house"), tag: 1)
        
        let writeTab = UINavigationController(rootViewController: UIViewController())
        writeTab.tabBarItem = UITabBarItem(title: "작성", image: UIImage(systemName: "pencil"), tag: 2)
        
        let searchTab = UINavigationController(rootViewController: SearchViewController())
        searchTab.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        
        let myPageTab = UINavigationController(rootViewController: MyProfileViewController())
        myPageTab.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person"), tag: 4)
        
        self.viewControllers = [homeTab, helpTab, writeTab, searchTab, myPageTab]
    }
}


// MARK: - Tabbar Delegate
extension TabBarController: UITabBarControllerDelegate {
    // tag 2번 선택 시 PHPickerVC present
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 5
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
            // 이미지를 저장할 빈 배열
            var images: [UIImage] = []
            
            // 결과가 비어있는지 확인
            guard !results.isEmpty else { return }
            
            // 반복문으로 UIImage 타입으로 변환 -> images 배열에 삽입
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
                                    writePostVC.postMode = .create
                                    writePostVC.hidesBottomBarWhenPushed = true
                                    
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

