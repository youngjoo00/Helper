//
//  WritePostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa

enum PostMode {
    case create
    case update
}

final class WritePostViewController: BaseViewController {

    private let mainView = WritePostView()
    private var viewModel = WritePostViewModel()
    
    private let dataListSubject = PublishSubject<[Data]>()
    var selectedImages: [UIImage] = []
    var postMode: PostMode = .create
    var postInfo: PostResponse.FetchPost?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        switch postMode {
        case .create:
            convertImagesToData()
        case .update:
            return
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        switch postMode {
        case .create:
            if self.isMovingFromParent {
                let vc = FindingViewController()
                vc.fetchTrigger.onNext(())
                self.tabBarController?.selectedIndex = 0
            }
        case .update:
            return
        }

    }
    
    override func bind() {

        let input = WritePostViewModel.Input(
            postMode: .just(postMode),
            postInfo: .just(postInfo),
            dataList: dataListSubject,
            hashTag: mainView.hashTagSubject,
            category: mainView.categorySubject,
            title: mainView.titleTextField.rx.text.orEmpty.asObservable(),
            feature: mainView.featureTextField.rx.text.orEmpty.asObservable(),
            region: mainView.regionSubject,
            locate: mainView.locateTextField.rx.text.orEmpty.asObservable(),
            date: mainView.datePicker.rx.date.asObservable(),
            phone: mainView.phoneTextField.rx.text.orEmpty.asObservable(),
            content: mainView.contentTextView.rx.text.orEmpty.asObservable(),
            completeButtonTap: mainView.completeButton.rx.tap
        )
        
        // MARK: - output
        let output = viewModel.transform(input: input)
        
        output.postInfo
            .drive(with: self) { owner, data in
                owner.mainView.updateView(data)
            }
            .disposed(by: disposeBag)
        
        // 이미지 콜렉션뷰
        output.files
            .drive(mainView.collectionView.rx.items(cellIdentifier: ImageCollectionViewCell.id,
                                                    cellType: ImageCollectionViewCell.self)) { row, item, cell in
                cell.updateImageView(item)
            }
            .disposed(by: disposeBag)
        
        // 에러 메세지
        output.errorMessage
            .drive(with: self) { owner, message in
                owner.showAlert(title: "오류!", message: message) {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        // 성공한 경우
        output.isWriteComplete
            .drive(with: self) { owner, complete in
                owner.showAlert(title: "성공!", message: "게시물 \(complete)에 성공했습니다") {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    
}


// MARK: - Custom Func
extension WritePostViewController {
    
    private func convertImagesToData() {
        var dataList: [Data] = []
        
        for image in selectedImages {
            if let data = image.pngData() {
                dataList.append(data)
            }
        }
        dataListSubject.onNext(dataList)
    }
    
    
}
