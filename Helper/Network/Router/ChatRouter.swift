//
//  ChatRouter.swift
//  Helper
//
//  Created by youngjoo on 5/29/24.
//

import Foundation
import Alamofire

enum ChatRouter {
    case createRoom(query: ChatRequest.CreateRoom)
    case roomList
    case chatList(roomID: String, query: ChatRequest.ChatList)
    case send(roomID: String, query: ChatRequest.Send)
    case imageUpload(roomID: String, files: [String])
}

extension ChatRouter: TargetType {
    
    var baseURL: String {
        PrivateKey.baseURL.rawValue
    }
    
    var header: [String : String] {
        let baseHeader = [
            HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
            HTTPHeader.sesacKey.rawValue: PrivateKey.sesac.rawValue
        ]
        switch self {
        case .createRoom, .roomList, .chatList, .send:
            return baseHeader
        case .imageUpload:
            return [
                HTTPHeader.sesacKey.rawValue: PrivateKey.sesac.rawValue,
                HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue
            ]
        }
    }
    
    var path: String {
        let version = PathVersion.v1.rawValue
        let chatPath = "chats"
        
        switch self {
        case .createRoom:
            return version + "/\(chatPath)"
        case .roomList:
            return version + "/\(chatPath)"
        case let .chatList(roomID, _):
            return version + "/\(chatPath)" + "/\(roomID)"
        case let .send(roomID, _):
            return version + "/\(chatPath)" + "/\(roomID)"
        case let .imageUpload(roomID, _):
            return version + "/\(chatPath)" + "/\(roomID)" + "/files"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createRoom:
            return .post
        case .roomList:
            return .get
        case .chatList:
            return .get
        case .send:
            return .post
        case .imageUpload:
            return .post
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .createRoom, .roomList, .send, .imageUpload:
            return nil
        case let .chatList(_, query):
            return [
                URLQueryItem(name: QueryItem.cursorDate.rawValue, value: query.cursorDate)
            ]
        }
    }
    
    var parameters: String? {
        nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .createRoom(let query):
            return try? encoder.encode(query)
        case .roomList:
            return nil
        case .chatList:
            return nil
        case let .send(_, query):
            return try? encoder.encode(query)
        case let .imageUpload(_, query):
            return try? encoder.encode(query)
        }
    }
    
}
