//
//  CommentRequest.swift
//  Helper
//
//  Created by youngjoo on 4/19/24.
//

import Foundation

enum CommentRequest {
    struct Create: Encodable {
        let postID: String
        let comment: String
    }

    struct Update: Encodable {
        let postID: String
        let commentID: String
        let comment: String
    }

    struct Delete {
        let postID: String
        let commentID: String
    }
}
