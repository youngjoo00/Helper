//
//  UserResponse.swift
//  Helper
//
//  Created by youngjoo on 4/17/24.
//

import Foundation

enum UserResponse {
    struct Join: Decodable {
        let userID: String
        let email: String
        let nick: String
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case email
            case nick
        }
    }
    
    struct Login: Decodable {
        let accessToken: String
        let refreshToken: String
    }

    struct ValidationEmail: Decodable {
        let message: String
    }
    
    struct MyProfile: Decodable {
        let userID: String
        let email: String
        let nick: String
        let phoneNum: String
        let birthDay: String
        let profileImage: String?
        let followers: [String]
        let following: [String]
        let posts: [String]
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case email
            case nick
            case phoneNum
            case birthDay
            case profileImage
            case followers
            case following
            case posts
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<UserResponse.MyProfile.CodingKeys> = try decoder.container(keyedBy: UserResponse.MyProfile.CodingKeys.self)
            self.userID = try container.decode(String.self, forKey: UserResponse.MyProfile.CodingKeys.userID)
            self.email = try container.decode(String.self, forKey: UserResponse.MyProfile.CodingKeys.email)
            self.nick = try container.decode(String.self, forKey: UserResponse.MyProfile.CodingKeys.nick)
            self.phoneNum = try container.decode(String.self, forKey: UserResponse.MyProfile.CodingKeys.phoneNum)
            self.birthDay = try container.decode(String.self, forKey: UserResponse.MyProfile.CodingKeys.birthDay)
            self.profileImage = try container.decodeIfPresent(String.self, forKey: UserResponse.MyProfile.CodingKeys.profileImage) ?? ""
            self.followers = try container.decode([String].self, forKey: UserResponse.MyProfile.CodingKeys.followers)
            self.following = try container.decode([String].self, forKey: UserResponse.MyProfile.CodingKeys.following)
            self.posts = try container.decode([String].self, forKey: UserResponse.MyProfile.CodingKeys.posts)
        }
    }
    
    struct Refresh: Decodable {
        let accessToken: String
    }
}
