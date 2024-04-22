//
//  MyPostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyPostViewController: BaseViewController {

    private let mainView = MyPostView()
    private let viewModel = MyPostViewModel()
    let fetchPostsTrigger = PublishSubject<Void>()
    
    override func loadView() {
        view = mainView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {

        let input = MyPostViewModel.Input(
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
            .delay(.seconds(1))
            .drive(mainView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

    }
}
