//
//  EditProfileViewController.swift
//  Helper
//
//  Created by youngjoo on 4/24/24.
//

import UIKit
import RxSwift
import RxCocoa

final class EditProfileViewController: BaseViewController {

    private let mainView = EditProfileView()
    private let viewModel = EditProfileViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
    }
    
    override func bind() {
        
        let seletedData = Observable.zip(mainView.profileInfoTableView.rx.itemSelected,
                       mainView.profileInfoTableView.rx.modelSelected([String].self))
        .map { indexPath, value in (indexPath.row, value[1]) }
        
        let input = EditProfileViewModel.Input(
            seletedData: seletedData
        )
        
        let output = viewModel.transform(input: input)
        
        output.profileInfo
            .drive(mainView.profileInfoTableView.rx.items(cellIdentifier: EditProfileTableViewCell.id,
                                               cellType: EditProfileTableViewCell.self)) { row, item, cell in
                cell.updateView(content: item[0], contentValue: item[1])
            }
            .disposed(by: disposeBag)
 
        output.nicknameTapped
            .drive(with: self) { owner, nickname in
                owner.transition(viewController: EditNicknameViewController(nickname: nickname), style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
        
        output.phoneTapped
            .drive(with: self) { owner, phone in
                owner.transition(viewController: EditPhoneViewController(phone: phone), style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation UI
extension EditProfileViewController {
    
    private func configureNavigation() {
        navigationItem.titleView = mainView.naviTitle
    }
}

