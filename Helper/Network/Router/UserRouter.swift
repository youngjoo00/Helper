//
//  Router.swift
//  LSLPBasic
//
//  Created by youngjoo on 4/10/24.
//

import Foundation
import Alamofire

enum UserRouter {
    case join(query: UserRequest.Join)
    case validationEmail(query: UserRequest.ValidationEmail)
    case login(query: UserRequest.Login)
    case withdraw
    case refresh
    case myProfile
}

extension UserRouter: TargetType {
    var baseURL: String {
        PrivateKey.baseURL.rawValue
    }
    
    var header: [String : String] {
        let baseHeader = [
            HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
            HTTPHeader.sesacKey.rawValue: PrivateKey.sesac.rawValue
        ]
        switch self {
        case .join:
            return baseHeader
        case .validationEmail:
            return baseHeader
        case .login:
            return baseHeader
        case .withdraw:
            return baseHeader
        case .refresh:
            var headers = baseHeader
            headers[HTTPHeader.authorization.rawValue] = UserDefaultsManager.shared.getAccessToken()
            headers[HTTPHeader.refresh.rawValue] = UserDefaultsManager.shared.getRefreshToken()
            return headers
        case .myProfile:
            return baseHeader
        }
    }
    
    var path: String {
        let version = "/v1"
        switch self {
        case .join:
            return version + "/users/join"
        case .validationEmail:
            return version + "/validation/email"
        case .login:
            return version + "/users/login"
        case .withdraw:
            return version + "/users/withdraw"
        case .refresh:
            return version + "/auth/refresh"
        case .myProfile:
            return version + "/users/me/profile"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .join:
            return .post
        case .validationEmail:
            return .post
        case .login:
            return .post
        case .withdraw:
            return .get
        case .refresh:
            return .get
        case .myProfile:
            return .get
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
        case .join(let query):
            return try? encoder.encode(query)
        case .validationEmail(let query):
            return try? encoder.encode(query)
        case .login(let query):
            return try? encoder.encode(query)
        case .withdraw:
            return nil
        case .refresh:
            return nil
        case .myProfile:
            return nil

        }
    }
    
    
}
