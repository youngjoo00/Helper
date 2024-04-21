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
        let storage: [String]
        let likes2: [String]
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
            case storage = "likes"
            case likes2
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
            storage = try container.decode([String].self, forKey: .storage)
            likes2 = try container.decode([String].self, forKey: .likes2)
            hashTags = try container.decode([String].self, forKey: .hashTags)
            comments = try container.decode([Comments].self, forKey: .comments)
        }
        
    }
    
    struct FilesModel: Decodable {
        let files: [String]
    }
    
    struct StorageStatus: Decodable {
        let storageStatus: Bool
        
        enum CodingKeys: String, CodingKey {
            case storageStatus = "like_status"
        }
    }
}
