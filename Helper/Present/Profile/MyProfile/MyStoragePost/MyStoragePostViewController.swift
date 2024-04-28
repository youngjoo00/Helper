//
//  MyStoragePostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyStoragePostViewController: BaseViewController {

    private let postsView = VerticalPostsView()
    private let viewModel = PostsViewModel(mode: .myStorage)
    
    let fetchPostsTrigger = PublishSubject<Void>()
    
    override func loadView() {
        view = postsView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPostsTrigger.onNext(())
    }
    
    override func bind() {

        // write 이벤트 감지
        EventManager.shared.postWriteTrigger
            .subscribe(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // storage 이벤트 감지
        EventManager.shared.storageTrigger
            .subscribe(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        let input = PostsViewModel.Input(
            fetchPostsTrigger: fetchPostsTrigger,
            reachedBottomTrigger: postsView.collectionView.rx.reachedBottom(),
            refreshControlTrigger: postsView.refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = viewModel.transform(input: input)
        
        output.posts
            .drive(postsView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.id,
                                                    cellType: PostCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)

        // refreshControl
        output.isRefreshControlLoading
            .drive(postsView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        // bottomIndicator
        output.isBottomLoading
            .drive(postsView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Transition DetailVC
        postsView.collectionView.rx.modelSelected(PostResponse.FetchPost.self)
            .subscribe(with: self) { owner, data in
                let vc = DetailPostViewController()
                vc.postID = data.postID
                owner.transition(viewController: vc, style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
    }
}
