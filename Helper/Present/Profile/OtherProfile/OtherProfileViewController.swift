//
//  OtherProfileViewController.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import Then
import RxSwift
import RxCocoa

final class OtherProfileViewController: BaseViewController {
    
    private let mainView = OtherProfileView()
    private let viewModel = OtherProfileViewModel()
    private let tabVC = OtherProfileTabViewController()
    private let userID = BehaviorSubject(value: "")
    
    init(userID: String) {
        self.userID.onNext(userID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabViewController()
    }
    
    override func bind() {
        let input = OtherProfileViewModel.Input(userID: userID)
        
        let output = viewModel.transform(input: input)
        
        output.profileInfo
            .drive(with: self) { owner, info in
                owner.mainView.updateView(info)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Add Child
extension OtherProfileViewController {
    
    func configureTabViewController() {
        addChild(tabVC)
        mainView.containerView.addSubview(tabVC.view)
        
        tabVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tabVC.didMove(toParent: self)
    }
    
}
