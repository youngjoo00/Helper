//
//  MyProfileViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import Hero

final class MyProfileViewController: BaseViewController {
    
    private let mainView = MyProfileView()
    private let viewModel = MyProfileViewModel()
    private let tabVC = MyProfileTabViewController()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabViewController()
        configureNavigationBar()
        
    }
    
    override func bind() {
        
        let input = MyProfileViewModel.Input(
            viewDidLoadTrigger: Observable.just(()),
            editProfileTap: mainView.profileEditButton.rx.tap
        )
        
        // 팔로워 Tap
        mainView.profileView.followersTapGesture.rx.event
            .subscribe(with: self) { owner, _ in
                owner.transition(viewController: FollowContainerViewController(.follower(userID: UserDefaultsManager.shared.getUserID())), style: .push)
            }
            .disposed(by: disposeBag)
        
        // 팔로잉 Tap
        mainView.profileView.followingTapGesture.rx.event
            .subscribe(with: self) { owner, _ in
                owner.transition(viewController: FollowContainerViewController(.following(userID: UserDefaultsManager.shared.getUserID())), style: .push)
            }
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.profileInfo
            .drive(with: self) { owner, data in
                owner.mainView.profileView.updateView(data)
            }
            .disposed(by: disposeBag)
        
        output.editProfileTap
            .drive(with: self) { owner, _ in
                owner.transition(viewController: EditProfileViewController(), style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
        
    }
    
}


// MARK: - Custom Func
extension MyProfileViewController {
    
    func configureNavigationBar() {
        let rightBtnItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(didRightBarButtonItemTapped))
        rightBtnItem.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItem = rightBtnItem
    }
    
    @objc private func didRightBarButtonItemTapped() {
        navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
}

// MARK: - Add Child
extension MyProfileViewController {
    
   func configureTabViewController() {
        addChild(tabVC)
        mainView.containerView.addSubview(tabVC.view)
        
        tabVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tabVC.didMove(toParent: self)
    }

}
