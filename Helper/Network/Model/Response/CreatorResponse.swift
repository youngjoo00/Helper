//
//  Creator.swift
//  Helper
//
//  Created by youngjoo on 4/19/24.
//

struct Creator: Decodable {
    let userID: String
    let nick: String
    let profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick
        case profileImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = try container.decode(String.self, forKey: .userID)
        nick = try container.decode(String.self, forKey: .nick)
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
    }
}
