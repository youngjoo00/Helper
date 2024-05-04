//
//  CommentViewController.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa
import Hero
import IQKeyboardManagerSwift

final class CommentViewController: BaseViewController {

    private let mainView = CommentView()
    private let viewModel = CommentViewModel()
    private let postID = BehaviorSubject(value: "")
    private let fetchPostsTrigger = BehaviorSubject<Void>(value: ())
        
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
    
    // sheetPresentationController 를 사용할 경우 IQKeyboard 와 충돌되어 이상하게 작동하니, 직접 핸들링 해야함
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = false
        configureKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enable = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func bind() {
        
        let commentDeleteTap = PublishSubject<String>()
        
        EventManager.shared.postWriteTrigger
            .bind(to: fetchPostsTrigger)
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
        
        mainView.commentWriteTextView.rx.text.orEmpty
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
                        let vc = item.creator.userID.checkedProfile
                        vc.isHeroEnabled = true
                        // 푸쉬와 유사한 전환 스타일 설정
                        vc.modalPresentationStyle = .fullScreen
                        vc.hero.modalAnimationType = .push(direction: .left)

                        // 프로필 화면 표시
                        owner.present(vc, animated: true, completion: nil)
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
                owner.mainView.updateCommentTextView()
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        // 댓글 삭제
        output.commentDeleteSuccess
            .drive(with: self) { owner, _ in
                owner.showTaost("댓글을 삭제했습니다")
                owner.mainView.updateCommentTextView()
            }
            .disposed(by: disposeBag)

        output.adjustTextViewHeight
            .drive(with: self) { owner, _ in
                owner.mainView.adjustTextViewHeight()
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - keyboard Handling
extension CommentViewController {
    
    private func configureKeyboardNotifications() {
        // 키보드 동작을 감지하는 Notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        // 1. 키보드 높이 가져옴
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let keyboardHeight = keyboardSize.height
        print("키보드 높이", keyboardHeight)
        
        // 2. safeAreaInset 하단 여백 높이를 구해야함 / 여기가 없으면 뷰가 위로 붕 뜸
        let safeAreaBottomInset = view.safeAreaInsets.bottom
        print("SafeAreaBottom", safeAreaBottomInset)
        
        // 3. 키보드 위로 뷰를 안착시키기 위해 연산
        let offset = keyboardHeight - safeAreaBottomInset
        print("offset", offset)
        
        // 4. bottomConstaraint 를 offset의 크기만큼 위로 업데이트
        mainView.bottomConstraint?.update(offset: -offset)
        
        // 5. 이게 없으면 뚝딱거리면서 올라감
        view.layoutIfNeeded()
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        // commentView의 하단 제약 조건을 원래대로 복구
        mainView.bottomConstraint?.update(offset: 0)
        view.layoutIfNeeded()
    }
    
}
