//
//  EditProfileViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/24/24.
//

import Foundation
import RxSwift
import RxCocoa

enum EditProfileList: CaseIterable {
    case email
    case nick
    case phone
    case birthDay
    
    var title: String {
        switch self {
        case .email: "이메일"
        case .nick: "닉네임"
        case .phone: "연락처"
        case .birthDay: "생년월일"
        }
    }
    
    func contentValue(_ info: UserResponse.MyProfile) -> String {
        switch self {
        case .email: info.email
        case .nick: info.nick
        case .phone: info.phoneNum
        case .birthDay: info.birthDay
        }
    }
}

final class EditProfileViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let editProfileImage: Observable<Data>
        let seletedData: Observable<(Int, String)>
    }
    
    struct Output {
        let profileImageString: Driver<String>
        let profileInfo: Driver<[[String]]>
        let nicknameTapped: Driver<String>
        let phoneTapped: Driver<String>
        let birthdayTapped: Driver<String>
        let successTrigger: Driver<Void>
        let errorToastMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let profileImageString = PublishRelay<String>()
        let nicknameTapped = PublishRelay<String>()
        let phoneTapped = PublishRelay<String>()
        let birthdayTapped = PublishRelay<String>()
        let successTrigger = PublishRelay<Void>()
        let errorToastMessage = PublishRelay<String>()
        
        let profileInfo = EventManager.shared.MyProfileInfo
            .compactMap { $0 }
            .do(onNext: { data in
                profileImageString.accept(data.profileImage)
            })
            .map { info -> [[String]] in
                // 인스턴스를 순회하며 1차원 배열 생성 후, 순회가 끝나면 2차원 배열로 반환
                EditProfileList.allCases.map { item in
                    [item.title, item.contentValue(info)]
                }
            }
        
        input.seletedData
            .subscribe(onNext: { row, data in
                switch row {
                case 0: break
                case 1: nicknameTapped.accept(data)
                case 2: phoneTapped.accept(data)
                case 3: break
                default: break
                }
            })
            .disposed(by: disposeBag)
        
        // 이미지 수정 API
        input.editProfileImage
            .flatMap { NetworkManager.shared.editprofileImageCall(type: UserResponse.MyProfile.self, router: Router.user(.editProfile(query: UserRequest.EditProfileImage(profile: ""))), imageData: $0) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    EventManager.shared.MyProfileInfo.onNext(data)
                    successTrigger.accept(())
                case .fail(let fail):
                    errorToastMessage.accept(fail.localizedDescription)
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            profileImageString: profileImageString.asDriver(onErrorJustReturn: ""),
            profileInfo: profileInfo.asDriver(onErrorJustReturn: []),
            nicknameTapped: nicknameTapped.asDriver(onErrorDriveWith: .empty()),
            phoneTapped: phoneTapped.asDriver(onErrorDriveWith: .empty()),
            birthdayTapped: birthdayTapped.asDriver(onErrorDriveWith: .empty()),
            successTrigger: successTrigger.asDriver(onErrorDriveWith: .empty()),
            errorToastMessage: errorToastMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다.")
        )
    }
    
}

