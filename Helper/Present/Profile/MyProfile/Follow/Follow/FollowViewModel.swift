//
//  FollowerViewModel.swift
//  Helper
//
//  Created by youngjoo on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa

struct DisplayFollow {
    let follow: UserResponse.Follow
    let isFollowing: Bool
}

final class FollowViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    var followViewMode: FollowViewMode
    
    init(followViewMode: FollowViewMode) {
        self.followViewMode = followViewMode
    }
    
    struct Input {
        let fetchProfileTrigger: Observable<Void>
        let followTap: Observable<DisplayFollow>
    }
    
    struct Output {
        let followers: Driver<[DisplayFollow]>
        let errorAlertMessage: Driver<String>
        let isRefreshLoading: Driver<Bool>
    }
    
    // 해당 유저의 ID 값을 갖고 팔로워 목록 확인
    // 내 팔로잉 목록 확인
    // 둘이 비교해서 같으면 "팔로잉" / 아니면 "팔로우"
    func transform(input: Input) -> Output {
        
        let followers = BehaviorRelay<[DisplayFollow]>(value: [])
        let myProfileInfo = EventManager.shared.myProfileInfo.compactMap { $0 }
        let responseProfileData = PublishSubject<UserResponse.OtherProfile>()
        let errorAlertMessage = PublishRelay<String>()
        let isRefreshLoading = PublishRelay<Bool>()

        // 프로필 조회 API
        input.fetchProfileTrigger
            .withUnretained(self)
            .flatMap { owner, userID in
                NetworkManager.shared.callAPI(type: UserResponse.OtherProfile.self, router: Router.user(.otherProfile(userID: owner.followViewMode.userID))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    responseProfileData.onNext(data)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 팔로잉 여부 확인 후 데이터 모델 방출
        Observable.zip(myProfileInfo, responseProfileData)
            .subscribe(with: self) { owner, data in
                let (myProfileInfo, responseProfileData) = data
                
                var displayModel: [DisplayFollow] = []

                switch owner.followViewMode {
                case .follower:
                    let result = FollowManager.shared.checkedFollowingList(myProfileInfo.following, otherFollowList: responseProfileData.followers)
                    
                    for (data, result) in zip(responseProfileData.followers, result) {
                        displayModel.append(DisplayFollow(follow: data, isFollowing: result))
                    }
                case .following:
                    let result = FollowManager.shared.checkedFollowingList(myProfileInfo.following, otherFollowList: responseProfileData.following)
                    
                    for (data, result) in zip(responseProfileData.following, result) {
                        displayModel.append(DisplayFollow(follow: data, isFollowing: result))
                    }
                }
                followers.accept(displayModel)
                isRefreshLoading.accept(false)
            }
            .disposed(by: disposeBag)
        
        // 팔로우 API
        input.followTap
            .flatMap { followData in
                if followData.isFollowing {
                    NetworkManager.shared.callAPI(type: FollowResponse.Follow.self,
                                                  router: Router.follow(.delete(userID: followData.follow.userID)))
                } else {
                    NetworkManager.shared.callAPI(type: FollowResponse.Follow.self,
                                                  router: Router.follow(.follow(userID: followData.follow.userID)))
                }
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success:
                    // 팔로우 진행 시 모든 화면 동기화를 위해 myInfo, follow Trigger 실행
                    EventManager.shared.myProfileInfoTrigger.onNext(())
                    EventManager.shared.followTrigger.onNext(())
                case .fail(let fail):
                    print(fail.localizedDescription)
                    errorAlertMessage.accept(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            followers: followers.asDriver(onErrorJustReturn: []), 
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: "알 수 없는 오류입니다."), 
            isRefreshLoading: isRefreshLoading.asDriver(onErrorJustReturn: false)
        )
    }
}
