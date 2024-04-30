//
//  FollowResponse.swift
//  Helper
//
//  Created by youngjoo on 4/30/24.
//

import Foundation

enum FollowResponse {
    struct Follow: Decodable {
        let nick: String
        let opponentNick: String
        let followingStatus: Bool
        
        enum CodingKeys: String, CodingKey {
            case nick
            case opponentNick = "opponent_nick"
            case followingStatus = "following_status"
        }
    }
}
