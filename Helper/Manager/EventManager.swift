//
//  EventManager.swift
//  Helper
//
//  Created by youngjoo on 4/24/24.
//

import RxSwift

final class EventManager {
    
    static let shared = EventManager()
    private init() { configureBinding() }
    
    private let disposeBag = DisposeBag()
    
    /// 게시물 작성/수정/삭제 시 사용
    let postWriteTrigger = PublishSubject<Void>()
    
    /// 게시물 저장 및 취소 시 사용
    let storageTrigger = PublishSubject<Void>()

    /// 프로필 요청 시 사용
    let myProfileInfoTrigger = PublishSubject<Void>()
  
    /// 팔로우 요청 시 사용
    let followTrigger = PublishSubject<Void>()
    
    /// 프로필 정보
    let myProfileInfo = BehaviorSubject<UserResponse.MyProfile?>(value: nil)
}

extension EventManager {
    
    // 메서드를 초기에 한 번 실행시킴으로써 구독, 외부에서는 메서드에 접근 불가능
    private func configureBinding() {
        myProfileInfoTrigger
            .debug("구독시작")
            .observe(on: MainScheduler.asyncInstance)
            .flatMap { NetworkManager.shared.callAPI(type: UserResponse.MyProfile.self, router: Router.user(.myProfile)) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    owner.myProfileInfo.onNext(data)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}
