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
    case fetchHashTag(query: PostRequest.FetchHashTag)
    case postID(id: String)
    case image(url: String)
    case uploadImage
    case create(query: PostRequest.Write)
    case update(query: PostRequest.Write, id: String)
    case delete(id: String)
    case storage(query: PostRequest.StorageStatus, id: String)
    case fetchStorage(next: String)
    case otherUserFetchPosts(next: String, userID: String)
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
        case .fetchHashTag, .postID, .create, .update, .delete, .storage, .fetchStorage, .otherUserFetchPosts:
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
        case .fetchHashTag:
            return version + posts + "/hashtags"
        case .postID(let id):
            return version + posts + "/\(id)"
        case .image(let url):
            return version + "/\(url)"
        case .uploadImage:
            return version + posts + "/files"
        case .create:
            return version + posts
        case .update(let query, let id):
            return version + posts + "/\(id)"
        case .delete(let id):
            return version + posts + "/\(id)"
        case .storage(let query, let id):
            return version + posts + "/\(id)" + "/like"
        case .fetchStorage:
            return version + posts + "/likes" + "/me"
        case .otherUserFetchPosts(let next, let userID):
            return version + posts + "/users" + "/\(userID)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchHashTag:
            return .get
        case .postID:
            return .get
        case .image:
            return .get
        case .uploadImage:
            return .post
        case .create:
            return .post
        case .delete:
            return .delete
        case .update:
            return .put
        case .storage:
            return .post
        case .fetchStorage:
            return .get
        case .otherUserFetchPosts:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchHashTag(let query):
            return [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: "50"),
                URLQueryItem(name: "product_id", value: query.productID),
                URLQueryItem(name: "hashTag", value: query.hashTag)
            ]
        case .postID, .image, .uploadImage, .create, .update, .delete, .storage:
            return nil
        case .fetchStorage(let next):
            return [
                URLQueryItem(name: "next", value: next),
                URLQueryItem(name: "limit", value: "50"),
            ]
        case .otherUserFetchPosts(let next, let id):
            return [
                URLQueryItem(name: "next", value: next),
                URLQueryItem(name: "limit", value: "6"),
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .fetchHashTag, .postID, .image, .uploadImage, .create, .update, .delete, .storage, .fetchStorage, .otherUserFetchPosts:
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .fetchHashTag:
            return nil
        case .postID:
            return nil
        case .image:
            return nil
        case .uploadImage:
            return nil
        case .create(let query):
            return try? encoder.encode(query)
        case .update(let query, let id):
            return try? encoder.encode(query)
        case .delete:
            return nil
        case .storage(let query, let id):
            return try? encoder.encode(query)
        case .fetchStorage(next: let next):
            return nil
        case .otherUserFetchPosts:
            return nil
        }
    }
}
