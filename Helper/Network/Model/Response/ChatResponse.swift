//
//  ChatResponse.swift
//  Helper
//
//  Created by youngjoo on 5/29/24.
//

import Foundation

enum ChatResponse {
    
    // MARK: - CreateChatRoom
    struct CreateRoom: Decodable {
        let roomID: String
        let createdAt: String
        let updatedAt: String
        let participants: [Participants]
        let lastChat: LastChat
        
        enum CodingKeys: String, CodingKey {
            case roomID = "room_id"
            case createdAt
            case updatedAt
            case participants
            case lastChat
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ChatResponse.CreateRoom.CodingKeys> = try decoder.container(keyedBy: ChatResponse.CreateRoom.CodingKeys.self)
            self.roomID = try container.decode(String.self, forKey: ChatResponse.CreateRoom.CodingKeys.roomID)
            self.createdAt = try container.decode(String.self, forKey: ChatResponse.CreateRoom.CodingKeys.createdAt)
            self.updatedAt = try container.decode(String.self, forKey: ChatResponse.CreateRoom.CodingKeys.updatedAt)
            self.participants = try container.decode([ChatResponse.Participants].self, forKey: ChatResponse.CreateRoom.CodingKeys.participants)
            self.lastChat = try container.decodeIfPresent(ChatResponse.LastChat.self, forKey: ChatResponse.CreateRoom.CodingKeys.lastChat) ?? LastChat(chatID: "", roomID: "", content: "", createdAt: "", sender: Sender(), files: [])
        }
    }
    
    struct Participants: Decodable {
        let userID: String
        let nick: String
        let profileImage: String
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case nick
            case profileImage
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ChatResponse.Participants.CodingKeys> = try decoder.container(keyedBy: ChatResponse.Participants.CodingKeys.self)
            self.userID = try container.decode(String.self, forKey: ChatResponse.Participants.CodingKeys.userID)
            self.nick = try container.decode(String.self, forKey: ChatResponse.Participants.CodingKeys.nick)
            self.profileImage = try container.decodeIfPresent(String.self, forKey: ChatResponse.Participants.CodingKeys.profileImage) ?? ""
        }
    }
    
    struct LastChat: Decodable {
        let chatID: String
        let roomID: String
        let content: String
        let createdAt: String
        let sender: Sender
        let files: [String]
        
        enum CodingKeys: String, CodingKey {
            case chatID = "chat_id"
            case roomID = "room_id"
            case content
            case createdAt
            case sender
            case files
        }
    }
    
    struct Sender: Decodable {
        let userID: String
        let nick: String
        let profileImage: String?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case nick
            case profileImage
        }
        
        init(userID: String = "", nick: String = "", profileImage: String? = nil) {
            self.userID = userID
            self.nick = nick
            self.profileImage = profileImage
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ChatResponse.Sender.CodingKeys> = try decoder.container(keyedBy: ChatResponse.Sender.CodingKeys.self)
            self.userID = try container.decode(String.self, forKey: ChatResponse.Sender.CodingKeys.userID)
            self.nick = try container.decode(String.self, forKey: ChatResponse.Sender.CodingKeys.nick)
            self.profileImage = try container.decodeIfPresent(String.self, forKey: ChatResponse.Sender.CodingKeys.profileImage)
        }
    }
    
    // MARK: - ChatRoomList
    struct RoomList: Decodable {
        let data: [RoomData]
    }
    
    struct RoomData: Decodable {
        let roomID: String
        let createdAt: String
        let updatedAt: String
        let participants: [Participants]
        let lastChat: LastChat?
        
        enum CodingKeys: String, CodingKey {
            case roomID = "room_id"
            case createdAt
            case updatedAt
            case participants
            case lastChat
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ChatResponse.RoomData.CodingKeys> = try decoder.container(keyedBy: ChatResponse.RoomData.CodingKeys.self)
            self.roomID = try container.decode(String.self, forKey: ChatResponse.RoomData.CodingKeys.roomID)
            self.createdAt = try container.decode(String.self, forKey: ChatResponse.RoomData.CodingKeys.createdAt)
            self.updatedAt = try container.decode(String.self, forKey: ChatResponse.RoomData.CodingKeys.updatedAt)
            self.participants = try container.decode([ChatResponse.Participants].self, forKey: ChatResponse.RoomData.CodingKeys.participants)
            self.lastChat = try container.decodeIfPresent(ChatResponse.LastChat.self, forKey: ChatResponse.RoomData.CodingKeys.lastChat) ?? LastChat(chatID: "", roomID: "", content: "", createdAt: "", sender: Sender(), files: [])
        }
    }
    
    // MARK: - ChatList
    struct ChatList: Decodable {
        let data: [ChatData]
    }
    
    struct ChatData: Decodable {
        let chatID: String
        let roomID: String
        let content: String
        let createdAt: String
        let sender: Sender
        let files: [String]
        
        enum CodingKeys: String, CodingKey {
            case chatID = "chat_id"
            case roomID = "room_id"
            case content
            case createdAt
            case sender
            case files
        }
    }
    
    // MARK: - ChatSend
    struct Send: Decodable {
        let chatID: String
        let roomID: String
        let content: String?
        let createdAt: String
        let sender: Sender
        let files: [String]?
        
        enum CodingKeys: String, CodingKey {
            case chatID = "chat_id"
            case roomID = "room_id"
            case content
            case createdAt
            case sender
            case files
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ChatResponse.Send.CodingKeys> = try decoder.container(keyedBy: ChatResponse.Send.CodingKeys.self)
            self.chatID = try container.decode(String.self, forKey: ChatResponse.Send.CodingKeys.chatID)
            self.roomID = try container.decode(String.self, forKey: ChatResponse.Send.CodingKeys.roomID)
            self.content = try container.decodeIfPresent(String.self, forKey: ChatResponse.Send.CodingKeys.content) ?? ""
            self.createdAt = try container.decode(String.self, forKey: ChatResponse.Send.CodingKeys.createdAt)
            self.sender = try container.decode(ChatResponse.Sender.self, forKey: ChatResponse.Send.CodingKeys.sender)
            self.files = try container.decodeIfPresent([String].self, forKey: ChatResponse.Send.CodingKeys.files) ?? []
        }
    }
    
    struct ImageUpload: Encodable {
        let files: [String]
    }
}
