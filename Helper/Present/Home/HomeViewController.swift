//
//  HomeViewController.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {

    private let mainView = HomeView()
    private let viewModel = HomeViewModel()
    
    private let findingViewModel = PostsViewModel(mode: .findingAll)
    private let foundViewModel = PostsViewModel(mode: .foundAll)
    
    let fetchPostsTrigger = PublishSubject<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPostsTrigger.onNext(())
        configureNavigationView()
    }
    
    override func bind() {
        findingBind()
        foundBind()
    }
}


// MARK: - Binding
extension HomeViewController {
    
    // MARK: - Finding
    func findingBind() {
        
        let input = PostsViewModel.Input(
            fetchPostsTrigger: fetchPostsTrigger,
            reachedBottomTrigger: mainView.recentPostsFindingView.collectionView.rx.reachedTrailing(),
            refreshControlTrigger: mainView.recentPostsFindingView.refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = findingViewModel.transform(input: input)
        
        output.posts
            .drive(mainView.recentPostsFindingView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.id,
                                                    cellType: PostCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)

        // refreshControl
        output.isRefreshControlLoading
            .drive(mainView.recentPostsFindingView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        // bottomIndicator
        output.isBottomLoading
            .drive(mainView.recentPostsFindingView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Transition DetailVC
        mainView.recentPostsFindingView.collectionView.rx.modelSelected(PostResponse.FetchPost.self)
            .subscribe(with: self) { owner, data in
                let vc = DetailPostViewController()
                vc.postID = data.postID
                owner.transition(viewController: vc, style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Found
    func foundBind() {
        
        let input = PostsViewModel.Input(
            fetchPostsTrigger: fetchPostsTrigger,
            reachedBottomTrigger: mainView.recentPostsFoundView.collectionView.rx.reachedTrailing(),
            refreshControlTrigger: mainView.recentPostsFoundView.refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = foundViewModel.transform(input: input)
        
        output.posts
            .drive(mainView.recentPostsFoundView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.id,
                                                    cellType: PostCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)

        // refreshControl
        output.isRefreshControlLoading
            .drive(mainView.recentPostsFoundView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        // bottomIndicator
        output.isBottomLoading
            .drive(mainView.recentPostsFoundView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Transition DetailVC
        mainView.recentPostsFoundView.collectionView.rx.modelSelected(PostResponse.FetchPost.self)
            .subscribe(with: self) { owner, data in
                let vc = DetailPostViewController()
                vc.postID = data.postID
                owner.transition(viewController: vc, style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    
    private func configureNavigationView() {
        navigationItem.titleView = mainView.naviTitle
    }
}
