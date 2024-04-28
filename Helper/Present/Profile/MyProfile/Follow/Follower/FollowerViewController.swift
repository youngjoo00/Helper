//
//  FollowerViewController.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FollowerViewController: BaseViewController {

    private let mainView = FollowerView()
    private let viewModel = FollowerViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        let input = FollowerViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.followers
            .drive(mainView.followerTableView.rx.items(cellIdentifier: FollowerTableViewCell.id,
                                                       cellType: FollowerTableViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
    }
}
