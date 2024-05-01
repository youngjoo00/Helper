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
    private var viewModel: FollowerViewModel
    private let fetchProfileTrigger = PublishSubject<Void>()
    
    init(userID: String) {
        self.viewModel = .init(userID: userID)
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
        
        fetchProfileTrigger.onNext(())
    }
    
    override func bind() {
        
        let followTap = PublishSubject<DisplayFollow>()
        
        let input = FollowerViewModel.Input(
            fetchProfileTrigger: fetchProfileTrigger,
            followTap: followTap
        )
        
        mainView.refreshControl.rx.controlEvent(.valueChanged)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ in () }
            .bind(to: fetchProfileTrigger)
            .disposed(by: disposeBag)
        
        mainView.followerTableView.rx.modelSelected(DisplayFollow.self)
            .subscribe(with: self) { owner, data in
                owner.transition(viewController: data.follow.userID.checkedProfile, style: .push)
            }
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.followers
            .drive(mainView.followerTableView.rx.items(cellIdentifier: FollowerTableViewCell.id,
                                                       cellType: FollowerTableViewCell.self)) { row, item, cell in
                cell.updateView(item)
                
                cell.followButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        followTap.onNext(item)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.isRefreshLoading
            .drive(mainView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}
