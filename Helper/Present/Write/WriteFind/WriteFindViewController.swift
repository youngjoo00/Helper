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

final class WriteFindViewController: BaseViewController {

    private let mainView = WriteFindView()
    private var viewModel = WriteFindViewModel()
    
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
            // 부모 뷰 컨트롤러나 네비게이션 스택에서 제거될 때 true 가 되면서 실행
            if self.isMovingFromParent {
                self.tabBarController?.selectedIndex = 0
            }
        case .update:
            return
        }

    }
    
    override func bind() {

        let input = WriteFindViewModel.Input(
            postMode: .just(postMode),
            postInfo: .just(postInfo),
            dataList: dataListSubject,
            hashTag: mainView.hashTagSubject,
            category: mainView.categorySubject,
            title: mainView.titleSubject,
            feature: mainView.featureSubject,
            region: mainView.regionSubject,
            locate: mainView.locateSubject,
            date: mainView.datePicker.rx.date.asObservable(),
            phone: mainView.phoneSubject,
            content: mainView.contentSubject,
            completeButtonTap: mainView.completeButton.rx.tap
        )
        
        // MARK: - Input
        mainView.titleTextField.rx.text.orEmpty
            .bind(to: mainView.titleSubject)
            .disposed(by: disposeBag)
        
        mainView.featureTextField.rx.text.orEmpty
            .bind(to: mainView.featureSubject)
            .disposed(by: disposeBag)
        
        mainView.locateTextField.rx.text.orEmpty
            .bind(to: mainView.locateSubject)
            .disposed(by: disposeBag)
        
        mainView.phoneTextField.rx.text.orEmpty
            .bind(to: mainView.phoneSubject)
            .disposed(by: disposeBag)
        
        mainView.contentTextView.rx.text.orEmpty
            .bind(to: mainView.contentSubject)
            .disposed(by: disposeBag)
        
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
        output.errorAlertMessage
            .drive(with: self) { owner, message in
                owner.showAlert(title: "오류!", message: message) {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.errorToastMessage
            .drive(with: self) { owner, message in
                owner.showTaost(message)
            }
            .disposed(by: disposeBag)
        
        // 성공한 경우
        output.isWriteComplete
            .drive(with: self) { owner, complete in
                owner.showAlert(title: "성공!", message: "게시물 \(complete)에 성공했습니다") {
                    EventManager.shared.postWriteTrigger.onNext(())
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    
}


// MARK: - Custom Func
extension WriteFindViewController {
    
    private func convertImagesToData() {
        var dataList: [Data] = []
        
        for image in selectedImages {
            if let data = image.jpegData(compressionQuality: 0.7) {
                dataList.append(data)
            }
        }
        dataListSubject.onNext(dataList)
    }
    
    
}
