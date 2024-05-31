//
//  ChatModel.swift
//  Helper
//
//  Created by youngjoo on 5/31/24.
//

import Foundation
import RealmSwift

final class ChatRoomRealm: Object {
    @Persisted(primaryKey: true) var roomID: String
    @Persisted var chatList: List<ChatRealm>
    
    convenience init(roomID: String) {
        self.init()
        self.roomID = roomID
        self.chatList = List<ChatRealm>()
    }
}

final class ChatRealm: Object {
    @Persisted(primaryKey: true) var chatID: String
    @Persisted var roomID: String
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var sender: SenderRealm?
    @Persisted var files: List<String>
    
    convenience init(chatID: String, roomID: String, content: String, createdAt: String, sender: SenderRealm, files: List<String>) {
        self.init()
        self.chatID = chatID
        self.roomID = roomID
        self.content = content
        self.createdAt = createdAt
        self.sender = sender
        self.files = files
    }
}

final class SenderRealm: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var userID: String
    @Persisted var nick: String
    @Persisted var profileImage: String
    
    convenience init(userID: String, nick: String, profileImage: String) {
        self.init()
        self.userID = userID
        self.nick = nick
        self.profileImage = profileImage
    }
}
