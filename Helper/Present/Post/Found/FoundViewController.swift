//
//  FoundViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FoundViewController: BaseViewController {

    private let mainView = FoundView()
    private let viewModel = FoundViewModel()

    let fetchTrigger = PublishSubject<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        EventManager.shared.postWriteTrigger
            .subscribe(with: self) { owner, _ in
                owner.fetchTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        fetchTrigger
            .debug("패치트리거")
            .subscribe(with: self) { owner, _ in
                print("감지")
            }
            .disposed(by: disposeBag)
        
        let input = FoundViewModel.Input(fetchTrigger: fetchTrigger,
                                           region: mainView.regionSubject,
                                           category: mainView.categorySegmentControl.rx.selectedSegmentIndex,
                                         reachedBottomTrigger: mainView.postsView.collectionView.rx.reachedBottom(),
                                           refreshControlTrigger: mainView.refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = viewModel.transform(input: input)
        
        // viewDidLoad 부터 fetchTrigger 를 여기서 담당함
        Observable.combineLatest(mainView.regionSubject, mainView.categorySegmentControl.rx.selectedSegmentIndex)
            .subscribe(with: self) { owner, _ in
                input.fetchTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // MARK: - 이 아래로 중복되는 코드 덩어리를 빼버리고 싶음
        output.posts
            .drive(mainView.postsView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.id,
                                                    cellType: PostCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
        
        // refreshControl
        output.isLoading
            .drive(mainView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        // Transition Detail
        Observable.zip(mainView.postsView.collectionView.rx.itemSelected,
                       mainView.postsView.collectionView.rx.modelSelected(PostResponse.FetchPost.self))
            .subscribe(with: self) { owner, value in
                let vc = DetailPostViewController()
                vc.postID = value.1.postID
                owner.transition(viewController: vc, style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
        
    }
}
