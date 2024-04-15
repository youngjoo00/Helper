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
    let postsID: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {

        let input = MyPostViewModel.Input(postID: postsID)
        let output = viewModel.transform(input: input)
        
        output.posts
            .drive(mainView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.id,
                                                    cellType: PostCollectionViewCell.self)) { row, item, cell in
                cell.updateCell(item)
            }
            .disposed(by: disposeBag)
    }
}
