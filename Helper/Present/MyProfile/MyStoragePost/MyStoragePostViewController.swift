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

    private let mainView = MyStoragePostView()
    private let viewModel = MyStorageViewModel()
    let fetchPostsTrigger = PublishSubject<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {

        let input = MyStorageViewModel.Input(
            fetchPostsTrigger: fetchPostsTrigger,
            reachedBottomTrigger: mainView.collectionView.rx.reachedBottom(),
            refreshControlTrigger: mainView.refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = viewModel.transform(input: input)
        
        output.posts
            .drive(mainView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.id,
                                                    cellType: PostCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)

        // refreshControl
        output.isLoading
            .drive(mainView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        // Transition DetailVC
        mainView.collectionView.rx.modelSelected(PostResponse.FetchPost.self)
            .subscribe(with: self) { owner, data in
                let vc = DetailPostViewController()
                vc.postID = data.postID
                owner.transition(viewController: vc, style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
    }
}
