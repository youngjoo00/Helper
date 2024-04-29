//
//  EditProfileViewController.swift
//  Helper
//
//  Created by youngjoo on 4/24/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class EditProfileViewController: BaseViewController {

    private let mainView = EditProfileView()
    private let viewModel = EditProfileViewModel()
    
    let editProfileImage = PublishSubject<Data>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
    }
    
    override func bind() {
        
        let seletedData = Observable.zip(mainView.profileInfoTableView.rx.itemSelected,
                       mainView.profileInfoTableView.rx.modelSelected([String].self))
        .map { indexPath, value in (indexPath.row, value[1]) }
        
        let input = EditProfileViewModel.Input(
            editProfileImage: editProfileImage,
            seletedData: seletedData
        )
        
        let output = viewModel.transform(input: input)
        
        // 프로필 이미지 버튼 클릭
        mainView.editProfileImageButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.editProfileAcionSheet {
                    owner.presentPHPicker()
                } deleteHandler: {
                    if let image = UIImage(named: "BlankProfileImage"), let imageData = image.pngData() {
                        owner.editProfileImage.onNext(imageData)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        // 프로필 이미지 변경
        output.profileImageString
            .drive(with: self) { owner, data in
                owner.mainView.updateProfileImageView(data)
            }
            .disposed(by: disposeBag)
        
        // 프로필 테이블뷰
        output.profileInfo
            .drive(mainView.profileInfoTableView.rx.items(cellIdentifier: EditProfileTableViewCell.id,
                                               cellType: EditProfileTableViewCell.self)) { row, item, cell in
                cell.updateView(content: item[0], contentValue: item[1])
            }
            .disposed(by: disposeBag)
 
        output.nicknameTapped
            .drive(with: self) { owner, nickname in
                owner.transition(viewController: EditNicknameViewController(nickname: nickname), style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
        
        output.phoneTapped
            .drive(with: self) { owner, phone in
                owner.transition(viewController: EditPhoneViewController(phone: phone), style: .hideBottomPush)
            }
            .disposed(by: disposeBag)
        
        output.successTrigger
            .drive(with: self) { owner, _ in
                owner.showTaost("프로필 이미지 편집 성공!")
            }
            .disposed(by: disposeBag)
        
        output.errorToastMessage
            .drive(with: self) { owner, message in
                owner.showTaost(message)
            }
            .disposed(by: disposeBag)
        
    }
}

// MARK: - Navigation UI
extension EditProfileViewController {
    
    private func configureNavigation() {
        navigationItem.titleView = mainView.naviTitle
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    
    func presentPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        // 선택한 사진이 있는지 확인
        let itemProvider = results.first?.itemProvider
        
        // 확인해서 옵셔널 바인딩 후 -> Image 인지 확인한다.
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            
            // 이미지를 불러온다.
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self else { return }
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        if let imageData = image.pngData() {
                            self.editProfileImage.onNext(imageData)
                        }
                    }
                }
            }
        }
    }
}
