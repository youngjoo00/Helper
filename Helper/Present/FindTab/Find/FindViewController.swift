//
//  PostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FindViewController: BaseViewController {

    private let mainView = FindView()
    private let findViewMode: FindViewModel

    let fetchPostsTrigger = PublishSubject<Void>()
    
    init(_ findViewMode: FindViewMode) {
        self.findViewMode = .init(findViewMode)
        
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
        
    }
    
    override func bind() {
        
        EventManager.shared.postWriteTrigger
            .subscribe(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        let input = FindViewModel.Input(
            fetchPostsTrigger: fetchPostsTrigger,
            reachedBottomTrigger: mainView.findView.collectionView.rx.reachedBottom(),
            refreshControlTrigger: mainView.findView.refreshControl.rx.controlEvent(.valueChanged),
            region: mainView.regionSubject,
            category: mainView.categorySegmentControl.rx.selectedSegmentIndex
        )
        
        let output = findViewMode.transform(input: input)
        
        output.posts
            .drive(mainView.findView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.id,
                                                    cellType: PostCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
        
        // bottomIndicator
        output.isBottomLoading
            .drive(mainView.findView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // refreshControl
        output.isRefreshControlLoading
            .drive(mainView.findView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        // viewDidLoad 부터 fetchTrigger 를 여기서 담당함
        Observable.combineLatest(mainView.regionSubject, mainView.categorySegmentControl.rx.selectedSegmentIndex)
            .subscribe(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // Transition DetailVC
        mainView.findView.collectionView.rx.modelSelected(PostResponse.FetchPost.self)
            .subscribe(with: self) { owner, data in
                let vc = DetailFindViewController()
                vc.postID = data.postID
                owner.transition(viewController: vc, style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
    }
}
