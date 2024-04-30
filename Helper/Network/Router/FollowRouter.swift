//
//  FollowRouter.swift
//  Helper
//
//  Created by youngjoo on 4/30/24.
//

import Foundation
import Alamofire

enum FollowRouter {
    case follow(userID: String)
    case delete(userID: String)
}

extension FollowRouter: TargetType {
    var baseURL: String {
        PrivateKey.baseURL.rawValue
    }
    
    var header: [String : String] {
        let baseHeader = [
            HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
            HTTPHeader.sesacKey.rawValue: PrivateKey.sesac.rawValue
        ]
        switch self {
        case .follow, .delete:
            return baseHeader
        }
    }
    
    var path: String {
        let version = PathVersion.v1.rawValue
        switch self {
        case .follow(let userID), .delete(let userID):
            return version + "/follow" + "/\(userID)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .follow:
            return .post
        case .delete:
            return .delete
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var parameters: String? {
        nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .follow, .delete:
            return nil
        }
    }
    
}
