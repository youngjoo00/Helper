//
//  PostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

enum Category: Int {
    case person = 0
    case animal = 1
    case item = 2
    
    var title: String {
        switch self {
        case .person:
            return "사람"
        case .animal:
            return "동물"
        case .item:
            return "물품"
        }
    }
}


final class FindViewController: BaseViewController {

    private let mainView = FindView()
    private let findViewMode: FindViewModel
    
    private let fetchPostsTrigger = PublishSubject<Void>()
    private let prouctID = BehaviorSubject(value: "")
    
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
        
        fetchPostsTrigger.onNext(())
    }
    
    override func bind() {

        EventManager.shared.postWriteTrigger
            .bind(to: fetchPostsTrigger)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(mainView.regionSubject, mainView.categorySegmentControl.rx.selectedSegmentIndex)
            .subscribe(with: self) { owner, data in
                guard let selectedCategory = Category(rawValue: data.1) else { return }

                let id = "\(data.0)_\(selectedCategory.title)"
                owner.prouctID.onNext(id)
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        let input = FindViewModel.Input(
            fetchPostsTrigger: fetchPostsTrigger,
            reachedBottomTrigger: mainView.findView.collectionView.rx.reachedBottom(),
            refreshControlTrigger: mainView.findView.refreshControl.rx.controlEvent(.valueChanged), 
            productID: prouctID
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
