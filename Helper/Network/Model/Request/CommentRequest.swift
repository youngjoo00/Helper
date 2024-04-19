//
//  CommentRequest.swift
//  Helper
//
//  Created by youngjoo on 4/19/24.
//

import Foundation

enum CommentRequest {
    struct Create {
        let postID: String
        let content: Content
    }

    struct Update {
        let postID: String
        let commentID: String
        let content: Content
    }

    struct Delete {
        let postID: String
        let commentID: String
    }
    
    struct Content: Encodable {
        let content: String
    }
}

