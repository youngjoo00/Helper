//
//  CommentResponse.swift
//  Helper
//
//  Created by youngjoo on 4/19/24.
//

import Foundation

struct Comments: Decodable {
    let commentID: String
    let content: String
    let createdAt: String
    let creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case content
        case createdAt
        case creator
    }
}

