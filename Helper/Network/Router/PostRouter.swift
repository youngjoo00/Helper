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
    case update(query: PostRequest.Write, id: String)
    case delete(id: String)
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
        case .posts, .postID, .write, .update, .delete:
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
        let version = PathVersion.v1.rawValue
        let posts = "/posts"
        switch self {
        case .posts:
            return version + posts
        case .postID(let id):
            return version + posts + "/\(id)"
        case .image(let url):
            return version + "/\(url)"
        case .uploadImage:
            return version + posts + "/files"
        case .write:
            return version + posts
        case .update(let query, let id):
            return version + posts + "/\(id)"
        case .delete(let id):
            return version + posts + "/\(id)"
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
        case .delete:
            return .delete
        case .update:
            return .put
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
        case .postID, .image, .uploadImage, .write, .update, .delete:
            return nil
        }
    }
    
    var parameters: String? {
        switch self {
        case .posts, .postID, .image, .uploadImage, .write, .update, .delete:
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
        case .update(let query, let id):
            return try? encoder.encode(query)
        case .delete:
            return nil
        }
    }
}
