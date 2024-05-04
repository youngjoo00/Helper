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
    case comment(CommentRouter)
    case follow(FollowRouter)
    case payment(PaymentRouter)
}

extension Router: TargetType {
    
    var baseURL: String {
        switch self {
        case .user(let userRouter):
            return userRouter.baseURL
        case .post(let postRouter):
            return postRouter.baseURL
        case .comment(let commentRouter):
            return commentRouter.baseURL
        case .follow(let followRouter):
            return followRouter.baseURL
        case .payment(let paymentRouter):
            return paymentRouter.baseURL
        }
    }

    var header: [String : String] {
        switch self {
        case .user(let userRouter):
            return userRouter.header
        case .post(let postRouter):
            return postRouter.header
        case .comment(let commentRouter):
            return commentRouter.header
        case .follow(let followRouter):
            return followRouter.header
        case .payment(let paymentRouter):
            return paymentRouter.header
        }
    }

    var path: String {
        switch self {
        case .user(let userRouter):
            return userRouter.path
        case .post(let postRouter):
            return postRouter.path
        case .comment(let commentRouter):
            return commentRouter.path
        case .follow(let followRouter):
            return followRouter.path
        case .payment(let paymentRouter):
            return paymentRouter.path
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .user(let userRouter):
            return userRouter.method
        case .post(let postRouter):
            return postRouter.method
        case .comment(let commentRouter):
            return commentRouter.method
        case .follow(let followRouter):
            return followRouter.method
        case .payment(let paymentRouter):
            return paymentRouter.method
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .user(let userRouter):
            return userRouter.queryItems
        case .post(let postRouter):
            return postRouter.queryItems
        case .comment(let commentRouter):
            return commentRouter.queryItems
        case .follow(let followRouter):
            return followRouter.queryItems
        case .payment(let paymentRouter):
            return paymentRouter.queryItems
        }
    }

    var parameters: String? {
        switch self {
        case .user(let userRouter):
            return userRouter.parameters
        case .post(let postRouter):
            return postRouter.parameters
        case .comment(let commentRouter):
            return commentRouter.parameters
        case .follow(let followRouter):
            return followRouter.parameters
        case .payment(let paymentRouter):
            return paymentRouter.parameters
        }
    }

    var body: Data? {
        switch self {
        case .user(let userRouter):
            return userRouter.body
        case .post(let postRouter):
            return postRouter.body
        case .comment(let commentRouter):
            return commentRouter.body
        case .follow(let followRouter):
            return followRouter.body
        case .payment(let paymentRouter):
            return paymentRouter.body
        }
    }
}
