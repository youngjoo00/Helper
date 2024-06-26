//
//  DetailPostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailFindViewController: BaseViewController {

    private let mainView = DetailFindView()
    private let viewModel = DetailFindViewModel()
    private let postIDSubject = PublishSubject<String>()
    private let postDeleteTap = PublishSubject<Void>()
    private let postEditMenuTap = PublishSubject<Void>()
    var postID = ""
    
    let rewardButtonTap = PublishSubject<Void>()
    let chatButtonTap = PublishSubject<Void>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        postIDSubject.onNext(postID)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        // 초기화 이후 재 바인딩을 통해 구독 설정
        disposeBag = DisposeBag()
        bind()
    }
    
    override func bind() {
        
        let commentDeleteTap = PublishSubject<String>()
        
        let input = DetailFindViewModel.Input(
            postID: postIDSubject,
            comment: mainView.commentWriteSubject,
            commentButtonTap: mainView.commentWriteButton.rx.tap,
            postDeleteTap: postDeleteTap,
            postEditMenuTap: postEditMenuTap,
            storageButtonTap: mainView.storageButton.rx.tap,
            completeButtonTap: mainView.completeButton.rx.tap,
            commentDeleteTap: commentDeleteTap,
            profileTapGesture: mainView.profileTabGesture.rx.event.map { _ in },
            rewardButtonTap: rewardButtonTap,
            chatButtonTap: chatButtonTap
        )
                
        mainView.commentWriteTextView.rx.text.orEmpty
            .bind(to: mainView.commentWriteSubject)
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
              
        output.checkedUserID
            .drive(with: self) { owner, value in
                if value {
                    owner.configureRewardNavigationBar()
                    owner.configureNavigationTitleChatButton()
                } else {
                    owner.configureMenuNavigationBar()
                }
                owner.mainView.completeButton.isUserInteractionEnabled = !value
            }
            .disposed(by: disposeBag)
        
        output.profileTapGesture
            .drive(with: self) { owner, id in
                owner.transition(viewController: id.checkedProfile, style: .push)
            }
            .disposed(by: disposeBag)
        
        // MARK: - View 관련 output
        output.profileImage
            .drive(with: self) { owner, urlString in
                owner.mainView.profileImageView.updateImage(urlString)
            }
            .disposed(by: disposeBag)
        
        output.nickname
            .drive(mainView.nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.regDate
            .drive(mainView.regDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 이미지 콜렉션뷰
        output.files
            .drive(mainView.imageCollectionView.rx.items(cellIdentifier: DetailFindCollectionViewCell.id,
                                                         cellType: DetailFindCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
        
        // 페이지 총 개수 / hidden 처리
        output.files
            .drive(with: self) { owner, value in
                let count = value.count
                owner.mainView.pageControl.numberOfPages = count
                owner.mainView.pageControl.hidesForSinglePage = true
                owner.mainView.titleLabelLayoutUpdate()
            }
            .disposed(by: disposeBag)
        
        // 현재 페이지
        mainView.imageCollectionView.rx.didEndDecelerating
            .subscribe(with: self) { owner, _ in
                let currentPage = owner.mainView.imageCollectionView.contentOffset.x / owner.mainView.imageCollectionView.frame.width
                owner.mainView.pageControl.currentPage = Int(currentPage)
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
        
        // 게시물 저장/저장취소
        output.storage
            .drive(with: self) { owner, state in
                owner.mainView.updateStorageButton(state)
            }
            .disposed(by: disposeBag)
        
        // 완료버튼
        output.complete
            .drive(with: self) { owner, state in
                owner.mainView.updateCompleteButton(state)
            }
            .disposed(by: disposeBag)
        
        output.content
            .drive(mainView.contentValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isrewardButtonHidden
            .drive(with: self) { owner, value in
                owner.navigationItem.rightBarButtonItem?.isHidden = value
            }
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
                        owner.transition(viewController: item.creator.userID.checkedProfile, style: .push)
                    }
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
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        output.commentDeleteSuccess
            .drive(with: self) { owner, _ in
                owner.showTaost("댓글을 삭제했습니다")
                owner.mainView.updateCommentTextField()
            }
            .disposed(by: disposeBag)
        
        output.adjustTextViewHeight
            .drive(with: self) { owner, _ in
                owner.mainView.adjustTextViewHeight()
            }
            .disposed(by: disposeBag)
        
        // 게시글 삭제 성공
        output.postDeleteSuccess
            .drive(with: self) { owner, _ in
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
                let vc = WriteFindViewController()
                vc.postInfo = data
                vc.postMode = .update
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 사례금
        output.rewardTap
            .drive(with: self) { owner, _ in
                owner.showAlertTextField(title: nil, message: "사례금 드리기") { price in
                    owner.transition(viewController: PaymentViewController(postID: owner.postID, price: price ?? ""), style: .hideBottomPush)
                }
            }
            .disposed(by: disposeBag)
        
        // 채팅
        output.chatTap
            .drive(with: self) { owner, info in
                owner.transition(viewController: ChatViewController(userID: info.creator.userID), style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Custom Func
extension DetailFindViewController {
    
    private func configureNavigationTitleChatButton() {
        navigationItem.titleView = mainView.titleView
        
        mainView.chatButton.rx.tap
            .bind(to: chatButtonTap)
            .disposed(by: disposeBag)
    }
    
    private func configureMenuNavigationBar() {
        
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
    
    private func configureRewardNavigationBar() {
        // 컨테이너 뷰 생성 및 크기 설정
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 100))
        
        let rewardButton = PointButton(title: "사례금")
        rewardButton.frame = CGRect(x: 0, y: 10, width: 80, height: 33)
            
        containerView.addSubview(rewardButton)
        let rightBtnItem = UIBarButtonItem(customView: containerView)
        
        navigationItem.rightBarButtonItem = rightBtnItem
        
        // RxSwift를 사용하여 버튼 탭 이벤트 처리
        rewardButton.rx.tap
            .bind(to: rewardButtonTap)
            .disposed(by: disposeBag)
    }
    
    private func showAlertTextField(title: String?, message: String?, completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            
            textField.placeholder = "금액을 입력하세요"
            textField.keyboardType = .numberPad
        }
        
        let action = UIAlertAction(title: "확인", style: .default) { text in
            completion(alert.textFields?[0].text)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}
