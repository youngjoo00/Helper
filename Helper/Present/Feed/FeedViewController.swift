//
//  FeedViewController.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FeedViewController: BaseViewController {

    private let mainView = FeedView()
    private let postsViewModel = PostsViewModel(mode: .feed)
    
    let fetchPostsTrigger = PublishSubject<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    override func bind() {
        
        EventManager.shared.postWriteTrigger
            .subscribe(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        let input = PostsViewModel.Input(
            fetchPostsTrigger: fetchPostsTrigger,
            reachedBottomTrigger: mainView.tableView.rx.reachedBottom(),
            refreshControlTrigger: mainView.refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = postsViewModel.transform(input: input)
        
        output.posts
            .drive(mainView.tableView.rx.items(cellIdentifier: FeedTableViewCell.id,
                                                    cellType: FeedTableViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)

        // refreshControl
        output.isRefreshControlLoading
            .drive(mainView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        // bottomIndicator
        output.isBottomLoading
            .drive(mainView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Transition DetailVC
        mainView.tableView.rx.modelSelected(PostResponse.FetchPost.self)
            .subscribe(with: self) { owner, data in
                let vc = DetailPostViewController()
                vc.postID = data.postID
                owner.transition(viewController: vc, style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
    }
}

extension FeedViewController {
    
    func configureNavigationBar() {
        navigationItem.titleView = mainView.navTitle
    }
}
