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
        
        self.tabBarController?.tabBar.isHidden = true
        postIDSubject.onNext(postID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func bind() {
        
        let input = DetailPostViewModel.Input(postID: postIDSubject,
                                              comment: mainView.commentTextField.rx.text.orEmpty.asObservable(),
                                              commentButtonTap: mainView.commentWriteButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
              
        output.checkedUserID
            .drive(with: self) { owner, value in
                owner.mainView.storageButton.isHidden = value
                owner.navigationItem.rightBarButtonItem?.isHidden = value
            }
            .disposed(by: disposeBag)
        
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
        
        output.region
            .drive(mainView.regionValueLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.locate
            .drive(mainView.locateValueeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.date
            .drive(mainView.dateValueLabel.rx.text)
            .disposed(by: disposeBag)

//        output.storage
//            .drive(mainView.dateValueLabel.rx.text)
//            .disposed(by: disposeBag)
        
        output.comments
            .drive(mainView.commentsTableView.rx.items(cellIdentifier: CommentsTableViewCell.id,
                                                       cellType: CommentsTableViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
        
        output.commentsCount
            .drive(with: self) { owner, text in
                owner.mainView.commentsLabel.text = text
                owner.mainView.performBatcUpdate()
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(with: self) { owner, message in
                owner.showAlert(title: "오류!", message: message) {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
}

// MARK: - Custom Func
extension DetailPostViewController {
    
    private func configureNavigationBar() {
        
        let menuItems = [
            UIAction(title: "수정", image: UIImage(systemName: "pencil")) { _ in
                print("edit")
            },
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                print("delete")
            }
        ]
        
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                                 image: UIImage(systemName: "line.3.horizontal"),
                                                                 primaryAction: nil,
                                                                 menu: menu)
    }
}
