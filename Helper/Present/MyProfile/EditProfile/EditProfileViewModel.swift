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
        let editProfileImageButtonTap: ControlEvent<Void>
        let seletedData: Observable<(Int, String)>
    }
    
    struct Output {
        let editProfileImageButtonTap: Driver<Void>
        let profileImageString: Driver<String>
        let profileInfo: Driver<[[String]]>
        let nicknameTapped: Driver<String>
        let phoneTapped: Driver<String>
        let birthdayTapped: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let profileImageString = PublishRelay<String>()
        let nicknameTapped = PublishRelay<String>()
        let phoneTapped = PublishRelay<String>()
        let birthdayTapped = PublishRelay<String>()
        
        let profileInfo = EventManager.shared.editProfileInfoSubject
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
        
        return Output(
            editProfileImageButtonTap: input.editProfileImageButtonTap.asDriver(), 
            profileImageString: profileImageString.asDriver(onErrorJustReturn: ""),
            profileInfo: profileInfo.asDriver(onErrorJustReturn: []),
            nicknameTapped: nicknameTapped.asDriver(onErrorDriveWith: .empty()),
            phoneTapped: phoneTapped.asDriver(onErrorDriveWith: .empty()),
            birthdayTapped: birthdayTapped.asDriver(onErrorDriveWith: .empty())
        )
    }
    
}

