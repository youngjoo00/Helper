//
//  InitailViewController.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class InitailViewController: BaseViewController {

    private let mainView = InitailView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaultsManager.shared.getUserID().isEmpty {
            changeSignInRootView()
        } else {
            NetworkManager.shared.callAPI(type: UserResponse.MyProfile.self, router: Router.user(.myProfile))
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let data):
                        UserDefaultsManager.shared.saveUserID(data.userID)
                        owner.changeHomeRootView()
                    case .fail(let fail):
                        print(fail.localizedDescription)
                        owner.changeSignInRootView()
                    }
                }
                .disposed(by: disposeBag)
        }
        
        
    }

}
