//
//  CommentViewController.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CommentViewController: BaseViewController {

    private let mainView = CommentView()
    private let viewModel = CommentViewModel()
    private let postID = BehaviorSubject(value: "")
    private let fetchPostsTrigger = BehaviorSubject<Void>(value: ())
    
    var profileTabDelegate: passProfileTabDelegate?
    
    init(_ postID: String) {
        self.postID.onNext(postID)
        self.fetchPostsTrigger.onNext(())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 포스트 조회
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let commentDeleteTap = PublishSubject<String>()
        
        EventManager.shared.postWriteTrigger
            .subscribe(with: self) { owner, _ in
                owner.fetchPostsTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        let input = CommentViewModel.Input(
            postID: postID,
            fetchPostsTrigger: fetchPostsTrigger,
            reachedBottomTrigger: mainView.commentsTableView.rx.reachedBottom(),
            comment: mainView.commentWriteSubject,
            commentButtonTap: mainView.commentWriteButton.rx.tap, 
            commentDeleteTap: commentDeleteTap
        )

        let output = viewModel.transform(input: input)
        
        mainView.commentWriteTextField.rx.text.orEmpty
            .bind(to: mainView.commentWriteSubject)
            .disposed(by: disposeBag)
        
        // 댓글 TableView 구성
        output.comments
            .drive(mainView.commentsTableView.rx.items(cellIdentifier: CommentsTableViewCell.id,
                                                       cellType: CommentsTableViewCell.self)) { row, item, cell in
                cell.updateView(item)
                
                // deleteMenu 선택 시 commentID 방출
                cell.deleteSubject
                    .bind(to: commentDeleteTap)
                    .disposed(by: cell.disposeBag)
                
                cell.profileTabGesture.rx.event
                    .subscribe(with: self) { owner, _ in
                        // 어 이거 어떻게하지?
//                        owner.transition(viewController: item.creator.userID.checkedProfile, style: .push)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        output.commentsCount
            .drive(mainView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 댓글 성공
        output.commentCreateSuccess
            .drive(with: self) { owner, _ in
                owner.mainView.updateCommentTextField()
            }
            .disposed(by: disposeBag)
        
        // 댓글 삭제
        output.commentDeleteSuccess
            .drive(with: self) { owner, _ in
                owner.showTaost("댓글을 삭제했습니다")
                owner.mainView.updateCommentTextField()
            }
            .disposed(by: disposeBag)

        // bottomIndicator
//        output.isBottomLoading
//            .drive(mainView.activityIndicator.rx.isAnimating)
//            .disposed(by: disposeBag)
    }
}
