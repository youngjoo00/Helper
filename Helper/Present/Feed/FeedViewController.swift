//
//  FeedViewController.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FeedViewController: BaseViewController {

    private let mainView = FeedView()
    private let postsViewModel = PostsViewModel(mode: .feed)
    private let feedViewModel = FeedViewModel()
    
    private let fetchPostsTrigger = PublishSubject<Void>()
    private let storageButtonTap = PublishSubject<PostResponse.FetchPost>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        fetchPostsTrigger.onNext(())
    }
    
    override func bind() {
        feedBind()
        postsBind()
    }
}


// MARK: - Bind
extension FeedViewController {
    
    private func postsBind() {
        EventManager.shared.postWriteTrigger
            .subscribe(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        EventManager.shared.storageTrigger
            .subscribe(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        let input = PostsViewModel.Input(
            fetchPostsTrigger: fetchPostsTrigger,
            reachedBottomTrigger: mainView.tableView.rx.reachedBottom(),
            refreshControlTrigger: mainView.refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = postsViewModel.transform(input: input)
        
        output.posts
            .drive(mainView.tableView.rx.items(cellIdentifier: FeedTableViewCell.id,
                                                    cellType: FeedTableViewCell.self)) { row, item, cell in
                cell.updateView(item)
                
                // 현재 페이지
                cell.scrollView.rx.didEndDecelerating
                    .subscribe(with: self) { owner, _ in
                        let currentPage = cell.scrollView.contentOffset.x / cell.scrollView.frame.width
                        cell.pageControl.currentPage = Int(currentPage)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.commentButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        let vc = CommentViewController(item.postID)
                        if let sheet = vc.sheetPresentationController {
                            sheet.detents = [.medium(), .large()]
                            // 스크롤할때 확장하지 않도록
                            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                            sheet.prefersGrabberVisible = true
                            sheet.preferredCornerRadius = 30
                        }
                        owner.present(vc, animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                
                // 셀을 탭하면 id 값 갖고 저장 네트워크 호출
                // 결과는 여기 뷰컨의 아웃풋에서 토스트메세지
                cell.storageButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        owner.storageButtonTap.onNext(item)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // refreshControl
        output.isRefreshControlLoading
            .drive(mainView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        // bottomIndicator
        output.isBottomLoading
            .drive(mainView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Transition DetailVC
        mainView.tableView.rx.modelSelected(PostResponse.FetchPost.self)
            .subscribe(with: self) { owner, data in
                let vc = DetailPostViewController()
                vc.postID = data.postID
                owner.transition(viewController: vc, style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
    }
    
    private func feedBind() {
        
        let input = FeedViewModel.Input(
            storageButtonTap: storageButtonTap
        )
        
        let output = feedViewModel.transform(input: input)

        // 게시물 저장 성공
        output.storageSuccess
            .drive(with: self) { owner, message in
                owner.showTaost(message)
            }
            .disposed(by: disposeBag)
        
    }
    
}


// MARK: - Navigation UI
extension FeedViewController {
    
    func configureNavigationBar() {
        navigationItem.titleView = mainView.navTitle
    }
}
