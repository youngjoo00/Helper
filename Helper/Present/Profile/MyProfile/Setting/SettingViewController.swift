//
//  SettingViewController.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingViewController: BaseViewController {

    private let mainView = SettingView()
    private let viewModel = SettingViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        let input = SettingViewModel.Input(viewDidLoadTrigger: Observable.just(()))
        
        let output = viewModel.transform(input: input)
        
        output.content
            .drive(mainView.tableView.rx.items(cellIdentifier: SettingTableViewCell.id,
                                               cellType: SettingTableViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)

        mainView.tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                if indexPath.row == 0 {
                    owner.showAlert(title: "로그아웃 하시겠습니까?", message: nil, btnTitle: "확인") {
                        owner.changeSignInRootView()
                    }
                } else {
                    owner.showAlert(title: "회원탈퇴", message: "모든 정보가 삭제됩니다!", btnTitle: "탈퇴") {
                        NetworkManager.shared.callAPI(type: UserResponse.Join.self, router: Router.user(.withdraw))
                            .subscribe(with: self) { owner, result in
                                switch result {
                                case .success:
                                    owner.changeSignInRootView()
                                case .fail(let fail):
                                    owner.showAlert(title: "오류!", message: fail.localizedDescription)
                                    print(fail)
                                }
                            }
                            .disposed(by: owner.disposeBag)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
