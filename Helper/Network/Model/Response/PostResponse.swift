//
//  PostResponse.swift
//  Helper
//
//  Created by youngjoo on 4/17/24.
//

import Foundation

enum PostResponse {
    struct Posts: Decodable {
        let data: [PostID]
        let nextCursor: String
        
        enum CodingKeys: String, CodingKey {
            case data
            case nextCursor = "next_cursor"
        }
    }
    
    
    struct PostID: Decodable {
        let postID: String
        let productId: String
        let title: String
        let content: String
        let content1: String
        let content2: String
        let content3: String
        let content4: String
        let content5: String
        let createdAt: String
        let creator: Creator
        let files: [String]
        let likes: [String]
        let hashTags: [String]
        let comments: [Comments]
        
        enum CodingKeys: String, CodingKey {
            case postID = "post_id"
            case productId = "product_id"
            case title
            case content
            case content1
            case content2
            case content3
            case content4
            case content5
            case createdAt
            case creator
            case files
            case likes
            case hashTags
            case comments
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<PostResponse.PostID.CodingKeys> = try decoder.container(keyedBy: PostResponse.PostID.CodingKeys.self)
            self.postID = try container.decode(String.self, forKey: PostResponse.PostID.CodingKeys.postID)
            self.productId = try container.decodeIfPresent(String.self, forKey: PostResponse.PostID.CodingKeys.productId) ?? ""
            self.title = try container.decode(String.self, forKey: PostResponse.PostID.CodingKeys.title)
            self.content = try container.decode(String.self, forKey: PostResponse.PostID.CodingKeys.content)
            self.content1 = try container.decodeIfPresent(String.self, forKey: PostResponse.PostID.CodingKeys.content1) ?? ""
            self.content2 = try container.decodeIfPresent(String.self, forKey: PostResponse.PostID.CodingKeys.content2) ?? ""
            self.content3 = try container.decodeIfPresent(String.self, forKey: PostResponse.PostID.CodingKeys.content3) ?? ""
            self.content4 = try container.decodeIfPresent(String.self, forKey: PostResponse.PostID.CodingKeys.content4) ?? ""
            self.content5 = try container.decodeIfPresent(String.self, forKey: PostResponse.PostID.CodingKeys.content5) ?? ""
            self.createdAt = try container.decode(String.self, forKey: PostResponse.PostID.CodingKeys.createdAt)
            self.creator = try container.decode(PostResponse.PostID.Creator.self, forKey: PostResponse.PostID.CodingKeys.creator)
            self.files = try container.decode([String].self, forKey: PostResponse.PostID.CodingKeys.files)
            self.likes = try container.decode([String].self, forKey: PostResponse.PostID.CodingKeys.likes)
            self.hashTags = try container.decode([String].self, forKey: PostResponse.PostID.CodingKeys.hashTags)
            self.comments = try container.decode([PostResponse.PostID.Comments].self, forKey: PostResponse.PostID.CodingKeys.comments)
        }
        
        struct Creator: Decodable {
            let userID: String
            let nick: String
            let profileImage: String?
            
            enum CodingKeys: String, CodingKey {
                case userID = "user_id"
                case nick
                case profileImage
            }
            
            init(from decoder: any Decoder) throws {
                let container: KeyedDecodingContainer<PostResponse.PostID.Creator.CodingKeys> = try decoder.container(keyedBy: PostResponse.PostID.Creator.CodingKeys.self)
                self.userID = try container.decode(String.self, forKey: PostResponse.PostID.Creator.CodingKeys.userID)
                self.nick = try container.decode(String.self, forKey: PostResponse.PostID.Creator.CodingKeys.nick)
                self.profileImage = try container.decodeIfPresent(String.self, forKey: PostResponse.PostID.Creator.CodingKeys.profileImage) ?? ""
            }
        }
        
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
        
        

    }
}
