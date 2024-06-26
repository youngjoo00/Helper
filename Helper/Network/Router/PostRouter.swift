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
    case complete(query: PostRequest.CompleteStatus, id: String)
    case fetchStorage(next: String)
    case otherUserFetchPosts(next: String, userID: String)
    case fetchFeed(query: PostRequest.FetchFeed)
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
        case .fetchHashTag, .postID, .create, .update, .delete, .storage, .complete, .fetchStorage, .otherUserFetchPosts, .fetchFeed:
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
        case let .update(_, id):
            return version + posts + "/\(id)"
        case .delete(let id):
            return version + posts + "/\(id)"
        case let .storage(_, id):
            return version + posts + "/\(id)" + "/like"
        case let .complete(_, id):
            return version + posts + "/\(id)" + "/like-2"
        case .fetchStorage:
            return version + posts + "/likes" + "/me"
        case let .otherUserFetchPosts(_, userID):
            return version + posts + "/users" + "/\(userID)"
        case .fetchFeed:
            return version + posts
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
        case .fetchFeed:
            return .get
        case .complete:
            return .post
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchHashTag(let query):
            return [
                URLQueryItem(name: QueryItem.next.rawValue, value: query.next),
                URLQueryItem(name: QueryItem.limit.rawValue, value: QueryItem.limitValue.rawValue),
                URLQueryItem(name: QueryItem.productID.rawValue, value: query.productID),
                URLQueryItem(name: QueryItem.hashTag.rawValue, value: query.hashTag)
            ]
        case .postID, .image, .uploadImage, .create, .update, .delete, .storage, .complete:
            return nil
        case .fetchStorage(let next):
            return [
                URLQueryItem(name: QueryItem.next.rawValue, value: next),
                URLQueryItem(name: QueryItem.limit.rawValue, value: QueryItem.limitValue.rawValue),
            ]
        case let .otherUserFetchPosts(next, _):
            return [
                URLQueryItem(name: QueryItem.next.rawValue, value: next),
                URLQueryItem(name: QueryItem.limit.rawValue, value: QueryItem.limitValue.rawValue),
            ]
        case .fetchFeed(let query):
            return [
                URLQueryItem(name: QueryItem.next.rawValue, value: query.next),
                URLQueryItem(name: QueryItem.limit.rawValue, value: QueryItem.limitValue.rawValue),
                URLQueryItem(name: QueryItem.productID.rawValue, value: query.productID),
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .fetchHashTag, .postID, .image, .uploadImage, .create, .update, .delete, .storage, .fetchStorage, .otherUserFetchPosts, .fetchFeed, .complete:
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
        case let .update(query, _):
            return try? encoder.encode(query)
        case .delete:
            return nil
        case let .storage(query, _):
            return try? encoder.encode(query)
        case let .complete(query, _):
            return try? encoder.encode(query)
        case .fetchStorage:
            return nil
        case .otherUserFetchPosts:
            return nil
        case .fetchFeed:
            return nil
        }
    }
}
