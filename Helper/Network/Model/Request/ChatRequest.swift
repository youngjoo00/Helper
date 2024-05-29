//
//  ChatRequest.swift
//  Helper
//
//  Created by youngjoo on 5/29/24.
//

import Foundation

enum ChatRequest {
    
    struct CreateRoom: Encodable {
        let opponentID: String
        
        enum CodingKeys: String, CodingKey {
            case opponentID = "opponent_id"
        }
    }
    
    struct ChatList: Encodable {
        let cursorDate: String
        
        enum CodingKeys: String, CodingKey {
            case cursorDate = "cursor_date"
        }
    }
    
    struct Send: Encodable {
        let content: String
        let files: [String]
    }
}
