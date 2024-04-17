//
//  WritePostViewController.swift
//  Helper
//
//  Created by youngjoo on 4/16/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WritePostViewController: BaseViewController {

    private let mainView = WritePostView()
    private let viewModel = WritePostViewModel()
    
    private let dataListSubject = PublishSubject<[Data]>()
    
    var selectedImages: [UIImage] = []
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        convertImagesToData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func bind() {
        // 버튼의 타이틀이 변경되면 이벤트를 보내고 싶어 어떻게 하는거지
        let input = WritePostViewModel.Input(dataList: dataListSubject,
                                             hashTag: mainView.hashTagSubject,
                                             category: mainView.categorySubject,
                                             title: mainView.titleTextField.rx.text.orEmpty.asObservable(),
                                             feature: mainView.featureTextField.rx.text.orEmpty.asObservable(),
                                             region: mainView.regionSubject,
                                             locate: mainView.locateTextField.rx.text.orEmpty.asObservable(),
                                             date: mainView.dateTextField.rx.text.orEmpty.asObservable(),
                                             phone: mainView.phoneTextField.rx.text.orEmpty.asObservable(),
                                             content: mainView.contentTextView.rx.text.orEmpty.asObservable(),
                                             completeButtonTap: mainView.completeButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        // 이미지 콜렉션뷰
        output.isUploadImage
            .map { [weak self] _ -> [UIImage] in
                guard let self else { return [] }
                return self.selectedImages
            }
            .drive(mainView.collectionView.rx.items(cellIdentifier: ImageCollectionViewCell.id,
                                                    cellType: ImageCollectionViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(with: self) { owner, message in
                owner.showAlert(title: "오류!", message: message) {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.isWriteComplete
            .drive(with: self) { owner, _ in
                owner.showAlert(title: "성공!", message: "게시물 작성에 성공했습니다") {
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
