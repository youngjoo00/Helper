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

    let fetchTrigger = PublishSubject<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTrigger.onNext(())
    }
    
    override func bind() {
        
        let input = FindingViewModel.Input(fetchTrigger: fetchTrigger,
                                           region: mainView.regionSubject,
                                           category: mainView.categorySegmentControl.rx.selectedSegmentIndex
        )
        
        let output = viewModel.transform(input: input)
        
        output.posts
            .drive(mainView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.id,
                                                    cellType: PostCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(mainView.collectionView.rx.itemSelected,
                       mainView.collectionView.rx.modelSelected(PostResponse.FetchPost.self))
            .subscribe(with: self) { owner, value in
                let vc = DetailPostViewController()
                vc.postID = value.1.postID
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}
