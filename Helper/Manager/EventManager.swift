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
    
    let postWriteTrigger = PublishSubject<Void>()
}
