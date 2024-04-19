//
//  CommentRouter.swift
//  Helper
//
//  Created by youngjoo on 4/19/24.
//

import Foundation
import Alamofire
import UIKit

enum CommentRouter {
    case create(CommentRequest.Create)
    case update(CommentRequest.Update)
    case delete(CommentRequest.Delete)
}

extension CommentRouter: TargetType {
    var baseURL: String {
        PrivateKey.baseURL.rawValue
    }
    
    var header: [String : String] {
        let baseHeader = [
            HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
            HTTPHeader.sesacKey.rawValue: PrivateKey.sesac.rawValue
        ]
        
        switch self {
        case .create, .update, .delete:
            return baseHeader
        }
    }
    
    var path: String {
        let version = PathVersion.v1.rawValue
        switch self {
        case .create(let query):
            return version + "/posts/\(query.postID)/comments"
        case .update(let query):
            return version + "/posts/\(query.postID)/comments/\(query.commentID)"
        case .delete(let query):
            return version + "/posts/\(query.postID)/comments/\(query.commentID)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .create:
            return .post
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .create, .update, .delete:
            return nil
        }
    }
    
    var parameters: String? {
        switch self {
        case .create, .update, .delete:
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .create(let query):
            return try? encoder.encode(query.content)
        case .update(let query):
            return try? encoder.encode(query.content)
        case .delete:
            return nil
        }
    }
}
