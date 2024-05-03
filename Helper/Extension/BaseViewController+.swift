//
//  BaseViewController+.swift
//  Helper
//
//  Created by youngjoo on 5/4/24.
//

import UIKit

extension BaseViewController {
    func changeHomeRootView() {
        NetworkManager.shared.callAPI(type: UserResponse.MyProfile.self, router: Router.user(.myProfile))
            .subscribe(with: self) { owner, result in
                LoadingIndicatorManager.shared.hideIndicator()
                switch result {
                case .success(let data):
                    UserDefaultsManager.shared.saveUserID(data.userID)
                    EventManager.shared.myProfileInfo.onNext(data)
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    let sceneDelegate = windowScene.delegate as? SceneDelegate
                    let tabbar = TabBarController()
                    sceneDelegate?.window?.rootViewController = tabbar
                    sceneDelegate?.window?.makeKey()
                case .fail(let fail):
                    owner.showAlert(title: "오류!", message: fail.localizedDescription) {
                        owner.changeSignInRootView()
                    }
                }
            } onFailure: { owner, error in
                owner.showAlert(title: "오류!", message: error.localizedDescription) {
                    owner.changeSignInRootView()
                }
            } onDisposed: { _ in
                print("dispose")
            }
            .disposed(by: disposeBag)
    }
    
    func changeSignInRootView() {
        LoadingIndicatorManager.shared.hideIndicator()
        UserDefaultsManager.shared.saveTokens("", refreshToken: "")
        UserDefaultsManager.shared.saveUserID("")
        EventManager.shared.myProfileInfo.onNext(nil)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        let sceneDelegate = windowScene.delegate as? SceneDelegate
        let nav = UINavigationController(rootViewController: SignInViewController())
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKey()
    }

    func showAlert(title: String?, message: String?, btnTitle: String, complectionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: btnTitle, style: .default) { _ in
            complectionHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func showAlert(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    /// 메세지와 확인버튼, completion 메서드
    func showAlert(title: String?, message: String?, complectionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .cancel) { _ in
            complectionHandler()
        }
        
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    /// 프로필 편집 액션 시트
    func editProfileAcionSheet(galleryHandler: @escaping () -> Void, deleteHandler: @escaping () -> Void) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let gallery = UIAlertAction(title: "이미지 수정", style: .default) { _ in
            galleryHandler()
        }
        
        let delete = UIAlertAction(title: "이미지 제거", style: .destructive) { _ in
            deleteHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(gallery)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }

}
