//
//  Router.swift
//  Helper
//
//  Created by youngjoo on 4/14/24.
//

import Foundation
import Alamofire

enum Router {
    case user(UserRouter)
    case post(PostRouter)
}

extension Router: TargetType {
    
    var baseURL: String {
        switch self {
        case .user(let userRouter):
            return userRouter.baseURL
        case .post(let postRouter):
            return postRouter.baseURL
        }
    }

    var header: [String : String] {
        switch self {
        case .user(let userRouter):
            return userRouter.header
        case .post(let postRouter):
            return postRouter.header
        }
    }

    var path: String {
        switch self {
        case .user(let userRouter):
            return userRouter.path
        case .post(let postRouter):
            return postRouter.path
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .user(let userRouter):
            return userRouter.method
        case .post(let postRouter):
            return postRouter.method
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .user(let userRouter):
            return userRouter.queryItems
        case .post(let postRouter):
            return postRouter.queryItems
        }
    }

    var parameters: String? {
        switch self {
        case .user(let userRouter):
            return userRouter.parameters
        case .post(let postRouter):
            return postRouter.parameters
        }
    }

    var body: Data? {
        switch self {
        case .user(let userRouter):
            return userRouter.body
        case .post(let postRouter):
            return postRouter.body
        }
    }
}
