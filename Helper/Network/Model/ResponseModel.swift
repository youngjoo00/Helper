//
//  Model.swift
//  LSLPBasic
//
//  Created by youngjoo on 4/10/24.
//

import Foundation

enum ResponseModel {
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
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case email
            case nick
        }
    }
    
    struct Refresh: Decodable {
        let accessToken: String
    }
    
    struct ErrorMessage: Decodable {
        let message: String
    }
}
