//
//  PostResponse.swift
//  Helper
//
//  Created by youngjoo on 4/17/24.
//

import Foundation

enum PostResponse {
    struct Posts: Decodable {
        let data: [FetchPost]
        let nextCursor: String
        
        enum CodingKeys: String, CodingKey {
            case data
            case nextCursor = "next_cursor"
        }
    }
    
    struct FetchPost: Decodable {
        let postID: String
        let productId: String
        let title: String
        let hashTag: String
        let feature: String
        let locate: String
        let date: String
        let phone: String
        let content: String
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
            case hashTag = "content"
            case feature = "content1"
            case locate = "content2"
            case date = "content3"
            case phone = "content4"
            case content = "content5"
            case createdAt
            case creator
            case files
            case likes
            case hashTags
            case comments
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            postID = try container.decode(String.self, forKey: .postID)
            productId = try container.decodeIfPresent(String.self, forKey: .productId) ?? ""
            title = try container.decode(String.self, forKey: .title)
            hashTag = try container.decode(String.self, forKey: .hashTag)
            feature = try container.decodeIfPresent(String.self, forKey: .feature) ?? ""
            locate = try container.decodeIfPresent(String.self, forKey: .locate) ?? ""
            date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
            phone = try container.decodeIfPresent(String.self, forKey: .phone) ?? ""
            content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
            createdAt = try container.decode(String.self, forKey: .createdAt)
            creator = try container.decode(Creator.self, forKey: .creator)
            files = try container.decode([String].self, forKey: .files)
            likes = try container.decode([String].self, forKey: .likes)
            hashTags = try container.decode([String].self, forKey: .hashTags)
            comments = try container.decode([Comments].self, forKey: .comments)
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
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                userID = try container.decode(String.self, forKey: .userID)
                nick = try container.decode(String.self, forKey: .nick)
                profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
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
    
    struct FilesModel: Decodable {
        let files: [String]
    }
}
