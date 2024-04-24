//
//  EventManager.swift
//  Helper
//
//  Created by youngjoo on 4/24/24.
//

import RxSwift

final class EventManager {
    
    static let shared = EventManager()
    private init() { }
    
    /// 게시물 작성 및 수정 시 사용
    let postWriteTrigger = PublishSubject<Void>()
    
    /// 프로필 수정 시 사용
    let editProfileTrigger = BehaviorSubject<UserResponse.MyProfile?>(value: nil)
}
