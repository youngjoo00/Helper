//
//  DetailPostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailPostViewController: BaseViewController {

    private let mainView = DetailPostView()
    private let viewModel = DetailPostViewModel()
    private let postIDSubject = PublishSubject<String>()
    private let postDeleteTap = PublishSubject<Void>()
    private let postEditMenuTap = PublishSubject<Void>()
    var postID = ""
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        postIDSubject.onNext(postID)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func bind() {
        
        let commentDeleteTap = PublishSubject<String>()
        
        let input = DetailPostViewModel.Input(postID: postIDSubject,
                                              comment: mainView.commentWriteSubject,
                                              commentButtonTap: mainView.commentWriteButton.rx.tap,
                                              postDeleteTap: postDeleteTap,
                                              postEditMenuTap: postEditMenuTap, 
                                              storageButtonTap: mainView.storageButton.rx.tap, 
                                              commentDeleteTap: commentDeleteTap
        )
                
        mainView.commentWriteTextField.rx.text.orEmpty
            .bind(to: mainView.commentWriteSubject)
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
              
        output.checkedUserID
            .drive(with: self) { owner, value in
                owner.mainView.storageButton.isHidden = value
                owner.navigationItem.rightBarButtonItem?.isHidden = value
            }
            .disposed(by: disposeBag)
        
        // MARK: - View 관련 output
        output.nickname
            .drive(mainView.nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.regDate
            .drive(mainView.regDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.files
            .drive(mainView.imageCollectionView.rx.items(cellIdentifier: DetailPostCollectionViewCell.id,
                                                         cellType: DetailPostCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
        
        output.title
            .drive(mainView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.category
            .drive(mainView.categoryLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.hashTag
            .drive(mainView.hashTagLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.feature
            .drive(mainView.featureValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.regionLocate
            .drive(mainView.regionLocateValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.date
            .drive(mainView.dateValueLabel.rx.text)
            .disposed(by: disposeBag)

        output.phone
            .drive(mainView.phoneValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.storage
            .drive(with: self) { owner, state in
                owner.mainView.updateStorageButton(state)
            }
            .disposed(by: disposeBag)
        
        output.content
            .drive(mainView.contentValueLabel.rx.text)
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
            }
            .disposed(by: disposeBag)
        
        mainView.commentsTableView.rx.modelSelected(Comments.self)
            .subscribe(with: self) { owner, data in
                print(data)
            }
            .disposed(by: disposeBag)
        
        output.commentsCount
            .drive(with: self) { owner, text in
                owner.mainView.commentsLabel.text = text
                owner.mainView.performBatcUpdate()
            }
            .disposed(by: disposeBag)
        
        // 댓글 성공
        output.commentCreateSuccess
            .drive(with: self) { owner, _ in
                owner.mainView.updateCommentTextField()
            }
            .disposed(by: disposeBag)
        
        output.commentDeleteSuccess
            .drive(with: self) { owner, _ in
                owner.showTaost("댓글을 삭제했습니다")
                owner.mainView.updateCommentTextField()
            }
            .disposed(by: disposeBag)
        
        // 게시글 삭제 성공
        output.postDeleteSuccess
            .drive(with: self) { owner, _ in
                let vc = FindingViewController()
                vc.fetchTrigger.onNext(())
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        // 저장 성공
        output.storageSuccess
            .drive(with: self) { owner, message in
                owner.showTaost(message)
            }
            .disposed(by: disposeBag)
        
        // 에러 Alert
        output.errorAlertMessage
            .drive(with: self) { owner, message in
                owner.showAlert(title: "오류!", message: message) {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        // 에러 Toast
        output.errorToastMessage
            .drive(with: self) { owner, message in
                owner.showTaost(message)
            }
            .disposed(by: disposeBag)
        
        // 게시물 수정 클릭
        output.postEditMenuTap
            .drive(with: self) { owner, data in
                let vc = WritePostViewController()
                vc.postInfo = data
                vc.postMode = .update
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Custom Func
extension DetailPostViewController {
    
    private func configureNavigationBar() {
        
        let menuItems = [
            UIAction(title: "수정", image: UIImage(systemName: "pencil")) { [weak self] _ in
                guard let self else { return }
                self.postEditMenuTap.onNext(())
            },
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                guard let self else { return }
                self.showAlert(title: "삭제", message: "게시물을 삭제하시겠습니까?", btnTitle: "삭제") {
                    self.postDeleteTap.onNext(())
                }
            }
        ]
        
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                                 image: UIImage(systemName: "line.3.horizontal"),
                                                                 primaryAction: nil,
                                                                 menu: menu)
    }
}
