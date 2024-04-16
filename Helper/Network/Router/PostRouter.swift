//
//  PostRouter.swift
//  Helper
//
//  Created by youngjoo on 4/14/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case posts(query: String)
    case postID(id: String)
    case image(url: String)
    case uploadImage
}

extension PostRouter: TargetType {
    var baseURL: String {
        PrivateKey.baseURL.rawValue
    }
    
    var header: [String : String] {
        let baseHeader = [
            HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
            HTTPHeader.sesacKey.rawValue: PrivateKey.sesac.rawValue
        ]
        switch self {
        case .posts:
            return baseHeader
        case .postID:
            return baseHeader
        case .image:
            var headers = baseHeader
            headers[HTTPHeader.authorization.rawValue] = UserDefaultsManager.shared.getAccessToken()
            return headers
        case .uploadImage:
            var headers = baseHeader
            headers[HTTPHeader.contentType.rawValue] = HTTPHeader.multipart.rawValue
            return headers
        }
    }
    
    var path: String {
        let version = "/v1"
        switch self {
        case .posts:
            return version + "/posts"
        case .postID(let id):
            return version + "/posts/\(id)"
        case .image(let url):
            return version + "/\(url)"
        case .uploadImage:
            return version + "/posts/files"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .posts:
            return .get
        case .postID:
            return .get
        case .image:
            return .get
        case .uploadImage:
            return .post
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .posts(let query):
            return [
                URLQueryItem(name: "next", value: "0"),
                URLQueryItem(name: "limit", value: "25"),
                URLQueryItem(name: "product_id", value: "서울_분실"),
            ]
        case .postID:
            return nil
        case .image:
            return nil
        case .uploadImage:
            return nil
        }
    }
    
    var parameters: String? {
        switch self {
        case .posts:
            return nil
        case .postID:
            return nil
        case .image:
            return nil
        case .uploadImage:
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .posts:
            return nil
        case .postID:
            return nil
        case .image:
            return nil
        case .uploadImage:
            return nil
        }
    }
}
