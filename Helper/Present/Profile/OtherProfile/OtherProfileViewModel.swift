//
//  OtherProfileViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class OtherProfileViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let fetchOtherProfile: Observable<String>
        let followTap: ControlEvent<Void>
    }
    
    struct Output {
        let profileInfo: Driver<UserResponse.OtherProfile>
        let postsID: PublishSubject<[String]>
        let checkedFollow: Driver<Bool>
        let errorAlertMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let profileInfo = PublishRelay<UserResponse.OtherProfile>()
        let postsID = PublishSubject<[String]>()
        
        let myInfo = EventManager.shared.myProfileInfo.compactMap { $0 }.debug("인포느 몇번?")
        
        let errorAlertMessage = PublishRelay<String>()
        
        // 다른 유저 프로필 조회
        input.fetchOtherProfile
            .debug("너는 몇번하니?")
            .flatMap { NetworkManager.shared.callAPI(type: UserResponse.OtherProfile.self, router: Router.user(.otherProfile(userID: $0))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    profileInfo.accept(data)
                case .fail(let fail):
                    print(fail.localizedDescription)
                    errorAlertMessage.accept(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 팔로우 중인지 확인
        let checkedFollow = profileInfo
            .withLatestFrom(myInfo) { otherInfo, myInfo in
                return myInfo.following.filter { $0.userID == otherInfo.userID }.count >= 1
            }
            .debug("팔로우 체크됐?")

        // 팔로우 API
        input.followTap
            .withLatestFrom(Observable.combineLatest(checkedFollow, input.fetchOtherProfile))
            .flatMap { isFollow, userID in
                if isFollow {
                    NetworkManager.shared.callAPI(type: FollowResponse.Follow.self, router: Router.follow(.delete(userID: userID)))
                } else {
                    NetworkManager.shared.callAPI(type: FollowResponse.Follow.self, router: Router.follow(.follow(userID: userID)))
                }
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    EventManager.shared.myProfileInfoTrigger.onNext(())
                    EventManager.shared.followTrigger.onNext(())
                case .fail(let fail):
                    print(fail.localizedDescription)
                    errorAlertMessage.accept(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    
        return Output(
            profileInfo: profileInfo.asDriver(onErrorDriveWith: .empty()),
            postsID: postsID,
            checkedFollow: checkedFollow.asDriver(onErrorJustReturn: false),
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다.")
        )
    }
}

