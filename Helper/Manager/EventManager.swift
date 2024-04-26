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
    
    /// 게시물 작성/수정/삭제 시 사용
    let postWriteTrigger = PublishSubject<Void>()
    
    /// 게시물 저장 및 취소 시 사용
    let storageTrigger = PublishSubject<Void>()
    
    /// 프로필 정보
    let MyProfileInfo = BehaviorSubject<UserResponse.MyProfile?>(value: nil)
}
