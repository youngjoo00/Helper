//
//  PostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FindingViewController: BaseViewController {

    private let mainView = FindingView()
    private let viewModel = FindingViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = FindingViewModel.Input(viewDidLoadTrigger: Observable.just(()), 
                                           selectedControlSegment: mainView.categorySegmentControl.rx.selectedSegmentIndex.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.posts
            .drive(mainView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.id,
                                                    cellType: PostCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
    }
}
