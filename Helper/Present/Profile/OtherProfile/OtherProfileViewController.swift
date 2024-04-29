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
    private var postsViewModel: PostsViewModel
    
    private let userID = BehaviorSubject(value: "")
    private let fetchPostsTrigger = PublishSubject<Void>()
    
    init(userID: String) {
        self.userID.onNext(userID)
        self.postsViewModel = .init(mode: .otherUserPosts(userID: userID))
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
        
        fetchPostsTrigger.onNext(())
    }
    
    override func bind() {
        otherProfileBind()
        postsBind()
    }
    
}

extension OtherProfileViewController {
    
    private func otherProfileBind() {
        let input = OtherProfileViewModel.Input(userID: userID)
        
        let output = viewModel.transform(input: input)
        
        output.profileInfo
            .drive(with: self) { owner, info in
                owner.mainView.updateView(info)
            }
            .disposed(by: disposeBag)
    }
    
    private func postsBind() {
        EventManager.shared.postWriteTrigger
            .subscribe(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        let input = PostsViewModel.Input(
            fetchPostsTrigger: fetchPostsTrigger,
            reachedBottomTrigger: mainView.profilePostsView.collectionView.rx.reachedBottom(),
            refreshControlTrigger: mainView.profilePostsView.refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = postsViewModel.transform(input: input)
        
        output.posts
            .debug("들어오나요?")
            .drive(mainView.profilePostsView.collectionView.rx.items(cellIdentifier: ProfilePostsCollectionViewCell.id,
                                                    cellType: ProfilePostsCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)

        // refreshControl
        output.isRefreshControlLoading
            .drive(mainView.profilePostsView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        // bottomIndicator
        output.isBottomLoading
            .drive(mainView.profilePostsView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Transition DetailVC
        mainView.profilePostsView.collectionView.rx.modelSelected(PostResponse.FetchPost.self)
            .subscribe(with: self) { owner, data in
                if data.checkedPostsKind {
                    owner.transition(viewController: DetailFeedViewController(feedID: data.postID), style: .hideBottomPush)
                } else {
                    let vc = DetailPostViewController()
                    vc.postID = data.postID
                    owner.transition(viewController: vc, style: .hideBottomPush)
                }
            }
            .disposed(by: disposeBag)
    }
}
