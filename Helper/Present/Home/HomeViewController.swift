//
//  HomeViewController.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import UIKit
import RxSwift
import RxCocoa

protocol BindPostWrite { }

final class HomeViewController: BaseViewController {

    private let mainView = HomeView()
    private let homeViewModel = HomeViewModel()
    
    private let recentPostsFromFollowingViewModel = RecentPostsFromFollowingViewModel()
    private let findingViewModel = PostsViewModel(mode: .findingAll)
    private let foundViewModel = PostsViewModel(mode: .foundAll)
    
    let fetchPostsTrigger = PublishSubject<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLogo()
        fetchPostsTrigger.onNext(())
        
    }
   
    override func bind() {
        homeBind()
        recentPostsFromFollowingBind()
        findingBind()
        foundBind()
        
        EventManager.shared.postWriteTrigger
            .bind(to: fetchPostsTrigger)
            .disposed(by: disposeBag)
        
        EventManager.shared.myProfileInfo
            .skip(1)
            .subscribe(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
    }
    
    override func handleNetworkReconnection(_ notification: Notification) {
        super.handleNetworkReconnection(notification)
        
        fetchPostsTrigger.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
}


// MARK: - Binding
extension HomeViewController {
    
    // MARK: - Home
    func homeBind() {
        let input = HomeViewModel.Input(refreshControlTrigger: mainView.refreshControl.rx.controlEvent(.valueChanged))
        
        let output = homeViewModel.transform(input: input)
        
        output.isFollowingEmpty
            .drive(with: self) { owner, value in
                owner.mainView.recentPostsFollowingTitleLabel.isHidden = value
                owner.mainView.recentPostsFollowingView.isHidden = value
            }
            .disposed(by: disposeBag)
        output.refreshControlTrigger
            .drive(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
                owner.mainView.refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Feed
    func recentPostsFromFollowingBind() {
        let input = RecentPostsFromFollowingViewModel.Input(
            fetchPostsTrigger: fetchPostsTrigger
        )
        
        let output = recentPostsFromFollowingViewModel.transform(input: input)
        
        output.posts
            .drive(mainView.recentPostsFollowingView.collectionView.rx.items(cellIdentifier: RecentPostsFromFollowingCollectionViewCell.id,
                                                    cellType: RecentPostsFromFollowingCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
        
        // Transition DetailVC
        mainView.recentPostsFollowingView.collectionView.rx.modelSelected(PostResponse.FetchPost.self)
            .subscribe(with: self) { owner, data in
                if data.checkedPostsKind {
                    owner.transition(viewController: DetailFeedViewController(feedID: data.postID), style: .hideBottomPush)
                } else {
                    let vc = DetailFindViewController()
                    vc.postID = data.postID
                    owner.transition(viewController: vc, style: .hideBottomPush)
                }
            }
            .disposed(by: disposeBag)
        
        output.errorToastMessage
            .drive(with: self) { owner, message in
                owner.showTaost(message)
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
