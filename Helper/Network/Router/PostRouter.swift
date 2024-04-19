//
//  PostRouter.swift
//  Helper
//
//  Created by youngjoo on 4/14/24.
//

import Foundation
import Alamofire
import UIKit

enum PostRouter {
    case posts(next: String, productID: String, hashTag: String)
    case postID(id: String)
    case image(url: String)
    case uploadImage
    case write(query: PostRequest.Write)
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
        case .write:
            return baseHeader
        }
    }
    
    var path: String {
        let version = PathVersion.v1.rawValue
        switch self {
        case .posts:
            return version + "/posts"
        case .postID(let id):
            return version + "/posts/\(id)"
        case .image(let url):
            return version + "/\(url)"
        case .uploadImage:
            return version + "/posts/files"
        case .write:
            return version + "/posts"
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
        case .write:
            return .post
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .posts(let next, let productID, let hashTag):
            return [
                URLQueryItem(name: "next", value: next),
                URLQueryItem(name: "limit", value: "200"),
                URLQueryItem(name: "product_id", value: productID),
                URLQueryItem(name: "hashTag", value: hashTag)
            ]
        case .postID:
            return nil
        case .image:
            return nil
        case .uploadImage:
            return nil
        case .write:
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
        case .write:
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
        case .write(let query):
            return try? encoder.encode(query)
        }
    }
}
