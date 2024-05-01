//
//  CheckedFollowingList.swift
//  Helper
//
//  Created by youngjoo on 5/1/24.
//

import Foundation

final class FollowManager {
    
    static let shared = FollowManager()
    private init() {}
    
    /// 내 팔로잉 목록과 다른 유저의 팔로우 목록을 비교한 결과를 Bool 배열로 반환합니다.
    func checkedFollowingList(_ myFollowingList: [UserResponse.Follow], otherFollowList: [UserResponse.Follow]) -> [Bool] {
        let myFollowingSet: Set<String> = Set(myFollowingList.map { $0.userID })
        print(myFollowingSet, otherFollowList)
        let checkedList = otherFollowList.map { myFollowingSet.contains($0.userID) }
        
        return checkedList
    }
}
