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
    
    private let feedViewModel = PostsViewModel(mode: .feed)
    private let findingViewModel = PostsViewModel(mode: .findingAll)
    private let foundViewModel = PostsViewModel(mode: .foundAll)
    
    let fetchPostsTrigger = PublishSubject<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationView()
        fetchPostsTrigger.onNext(())
    }
    
    override func bind() {
        feedBind()
        findingBind()
        foundBind()
        
        EventManager.shared.postWriteTrigger
            .subscribe(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - Binding
extension HomeViewController {
    
    // MARK: - Feed
    func feedBind() {
        let input = PostsViewModel.Input(
            fetchPostsTrigger: fetchPostsTrigger,
            reachedBottomTrigger: mainView.recentPostsFollowingView.collectionView.rx.reachedTrailing(),
            refreshControlTrigger: mainView.recentPostsFollowingView.refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = feedViewModel.transform(input: input)
        
        output.posts
            .drive(mainView.recentPostsFollowingView.collectionView.rx.items(cellIdentifier: RecentPostsFromFollowingCollectionViewCell.id,
                                                    cellType: RecentPostsFromFollowingCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)

        // refreshControl
        output.isRefreshControlLoading
            .drive(mainView.recentPostsFollowingView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        // bottomIndicator
        output.isBottomLoading
            .drive(mainView.recentPostsFollowingView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Transition DetailVC
        mainView.recentPostsFollowingView.collectionView.rx.modelSelected(PostResponse.FetchPost.self)
            .subscribe(with: self) { owner, data in
                owner.transition(viewController: DetailFeedViewController(feedID: data.postID), style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
    }
    
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
                let vc = DetailFindViewController()
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
                let vc = DetailFindViewController()
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
