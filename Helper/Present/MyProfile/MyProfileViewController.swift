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
        
    }
    
    override func bind() {
        let input = MyProfileViewModel.Input(viewDidLoadTrigger: Observable.just(()))
        
        let output = viewModel.transform(input: input)
        
        output.nickname
            .drive(mainView.nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 탭맨으로 자식 VC 를 놨다면 반드시 반드시 반드시 값 넘길때 자식VC 로 넘기자.,.., (여기에 24시간 사용)
        output.postsID
            .bind(with: self) { owner, ids in
                // 자식 VC 중에 MyPostVC 찾기
                if let myPostVC = owner.tabVC.viewControllers.first(where: { $0 is MyPostViewController }) as? MyPostViewController {
                    myPostVC.postsID.onNext(ids)
                }
            }
            .disposed(by: disposeBag)
    }
    
}


// MARK: - Custom Func
extension MyProfileViewController {
    
    private func configureTabViewController() {
        addChild(tabVC)
        mainView.containerView.addSubview(tabVC.view)
        
        tabVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tabVC.didMove(toParent: self)
    }
}