//
//  WriteFeedViewController.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class WriteFeedViewController: BaseViewController {

    private let mainView = WriteFeedView()
    private var viewModel: WriteFeedViewModel
    
    // 이미지 converting
    private let dataListSubject = PublishSubject<[Data]>()
    var selectedImages: [UIImage] = []
    
    var postMode: PostMode
    
    init(selectedImages: [UIImage], postMode: PostMode, postInfo: PostResponse.FetchPost? = nil) {
        self.selectedImages = selectedImages
        self.postMode = postMode
        
        if let postInfo {
            mainView.updateView(postInfo)
            viewModel = .init(postID: postInfo.postID ,postMode: .update, postInfo: postInfo)
        } else {
            viewModel = .init(postMode: .create, postInfo: nil)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                self.tabBarController?.selectedIndex = 3
            }
        case .update:
            return
        }

    }
    
    override func bind() {

        let input = WriteFeedViewModel.Input(
            dataList: dataListSubject,
            title: mainView.titleTextView.rx.text.orEmpty.asObservable(),
            completeButtonTap: mainView.completeButton.rx.tap
        )
        
        // MARK: - output
        let output = viewModel.transform(input: input)
        
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
extension WriteFeedViewController {
    
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
