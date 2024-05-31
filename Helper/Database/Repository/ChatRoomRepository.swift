//
//  ChatRepository.swift
//  Helper
//
//  Created by youngjoo on 5/31/24.
//

import Foundation
import RealmSwift

final class ChatRoomRepository {
    
    let realm = try! Realm()
    
    /// 채팅방이 존재하지 않다면 생성합니다.
    func createChatRoomIfNeeded(roomID: String) throws {
        if fetchChatRoom(roomID: roomID) == nil {
            let newChatRoom = ChatRoomRealm(roomID: roomID)
            do {
                try createChatRoomItem(newChatRoom)
            } catch {
                throw error
            }
        }
    }
    
    /// 전체 채팅 내역을 가져옵니다.
    func fetchChatAllList(_ roomID: String) -> [ChatRealm] {
        guard let chatRoom = fetchChatRoom(roomID: roomID) else { return [] }
        return Array(chatRoom.chatList)
    }
    
    /// 마지막 채팅 날짜를 가져옵니다.
    func fetchChatLastCreatedAt(_ roomID: String) -> String {
        guard let chatRoom = fetchChatRoom(roomID: roomID) else { 
            print("roomID 없음")
            return ""
        }
        return chatRoom.chatList.last?.createdAt ?? ""
    }
}

extension ChatRoomRepository {
    
    private func createChatRoomItem<T: Object>(_ item: T) throws {
        do {
            try realm.write {
                realm.add(item)
                print(realm.configuration.fileURL!)
            }
        } catch {
            print("create 실패")
            throw error
        }
    }
    
    /// 전체 채팅 방에서 roomID 에 해당하는 테이블을 가져옵니다.
    private func fetchChatRoom(roomID: String) -> ChatRoomRealm? {
        return realm.objects(ChatRoomRealm.self).filter("roomID == %@", roomID).first
    }
}
