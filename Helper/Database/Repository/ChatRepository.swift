//
//  ChatRepository.swift
//  Helper
//
//  Created by youngjoo on 5/31/24.
//

import Foundation
import RealmSwift

final class ChatRepository {
    
    let realm = try! Realm()
    
    func createChatItem(_ chat: ChatRealm, roomID: String) throws {
        do {
            try realm.write {
                if let chatRoom = realm.objects(ChatRoomRealm.self).filter("roomID == %@", roomID).first {
                    chatRoom.chatList.append(chat)
                }
            }
        } catch {
            print("create 실패")
            throw error
        }
    }
}

extension ChatRepository {
    

}
