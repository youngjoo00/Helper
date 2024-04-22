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
                                           category: mainView.categorySegmentControl.rx.selectedSegmentIndex,
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

        Observable.combineLatest(mainView.regionSubject, mainView.categorySegmentControl.rx.selectedSegmentIndex)
            .subscribe(with: self) { owner, _ in
                input.fetchTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // Transition Detail
        Observable.zip(mainView.collectionView.rx.itemSelected,
                       mainView.collectionView.rx.modelSelected(PostResponse.FetchPost.self))
            .subscribe(with: self) { owner, value in
                let vc = DetailPostViewController()
                vc.postID = value.1.postID
                owner.transition(viewController: vc, style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
        
    }
}
