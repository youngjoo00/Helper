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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        postIDSubject.onNext(postID)
    }
    
    override func bind() {
        let input = DetailPostViewModel.Input(postID: postIDSubject)
        
        let output = viewModel.transform(input: input)
               
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
        
        output.errorMessage
            .drive(with: self) { owner, message in
                owner.showAlert(title: "오류!", message: message) {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
}
