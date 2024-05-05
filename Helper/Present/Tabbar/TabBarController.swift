//
//  TabBarController.swift
//  Helper
//
//  Created by youngjoo on 4/12/24.
//

import UIKit
import PhotosUI

final class TabBarController: UITabBarController {
    
    var selectedWriteMode: WriteMode = .help
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let homeTab = UINavigationController(rootViewController: HomeViewController())
        homeTab.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let helpTab = UINavigationController(rootViewController: FindContainerViewController())
        helpTab.tabBarItem = UITabBarItem(title: "Help", image: UIImage(systemName: "megaphone"), tag: 1)
        
        let writeTab = UINavigationController(rootViewController: UIViewController())
        writeTab.tabBarItem = UITabBarItem(title: "Post", image: UIImage(systemName: "pencil"), tag: 2)
        
        let searchTab = UINavigationController(rootViewController: FeedViewController())
        searchTab.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "book.pages"), tag: 3)
        
        let myPageTab = UINavigationController(rootViewController: MyProfileViewController())
        myPageTab.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
        
        self.viewControllers = [homeTab, helpTab, writeTab, searchTab, myPageTab]
    }
}




// MARK: - Tabbar Delegate
extension TabBarController: UITabBarControllerDelegate {

    enum WriteMode {
        case help
        case feed
    }
    
    // tag 2번 선택 시 PHPickerVC present
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            
            writeModeAcionSheet {
                self.selectedWriteMode = .help
                self.presentPHPicker()
            } feedHandler: {
                self.selectedWriteMode = .feed
                self.presentPHPicker()
            }

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
                                    switch self.selectedWriteMode {
                                    case .help:
                                        let writePostVC = WriteFindViewController()
                                        writePostVC.selectedImages = images
                                        writePostVC.postMode = .create
                                        writePostVC.hidesBottomBarWhenPushed = true
                                        
                                        if let navController = self.selectedViewController as? UINavigationController {
                                            navController.pushViewController(writePostVC, animated: true)
                                        }
                                    case .feed:
                                        let writeFeedVC = WriteFeedViewController(selectedImages: images, postMode: .create)
                                        writeFeedVC.hidesBottomBarWhenPushed = true
                                        
                                        if let navController = self.selectedViewController as? UINavigationController {
                                            navController.pushViewController(writeFeedVC, animated: true)
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
}

extension TabBarController {
    
    /// 포스트 작성 모드 선택하는 액션시트
    func writeModeAcionSheet(helpHandler: @escaping () -> Void, feedHandler: @escaping () -> Void) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let help = UIAlertAction(title: "Help 게시물 작성", style: .default) { _ in
            helpHandler()
        }
        
        let feed = UIAlertAction(title: "Feed 게시물 작성", style: .default) { _ in
            feedHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(help)
        actionSheet.addAction(feed)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    func presentPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    
}
