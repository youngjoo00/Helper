//
//  Model.swift
//  LSLPBasic
//
//  Created by youngjoo on 4/10/24.
//

import Foundation

enum ResponseModel {
    
    // MARK: - User Model
    struct Join: Decodable {
        let userID: String
        let email: String
        let nick: String
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case email
            case nick
        }
    }
    
    struct Login: Decodable {
        let accessToken: String
        let refreshToken: String
    }

    struct ValidationEmail: Decodable {
        let message: String
    }
    
    struct MyProfile: Decodable {
        let userID: String
        let email: String
        let nick: String
        let phoneNum: String
        let birthDay: String
        let profileImage: String?
        let followers: [String]
        let following: [String]
        let posts: [String]
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case email
            case nick
            case phoneNum
            case birthDay
            case profileImage
            case followers
            case following
            case posts
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ResponseModel.MyProfile.CodingKeys> = try decoder.container(keyedBy: ResponseModel.MyProfile.CodingKeys.self)
            self.userID = try container.decode(String.self, forKey: ResponseModel.MyProfile.CodingKeys.userID)
            self.email = try container.decode(String.self, forKey: ResponseModel.MyProfile.CodingKeys.email)
            self.nick = try container.decode(String.self, forKey: ResponseModel.MyProfile.CodingKeys.nick)
            self.phoneNum = try container.decode(String.self, forKey: ResponseModel.MyProfile.CodingKeys.phoneNum)
            self.birthDay = try container.decode(String.self, forKey: ResponseModel.MyProfile.CodingKeys.birthDay)
            self.profileImage = try container.decodeIfPresent(String.self, forKey: ResponseModel.MyProfile.CodingKeys.profileImage) ?? ""
            self.followers = try container.decode([String].self, forKey: ResponseModel.MyProfile.CodingKeys.followers)
            self.following = try container.decode([String].self, forKey: ResponseModel.MyProfile.CodingKeys.following)
            self.posts = try container.decode([String].self, forKey: ResponseModel.MyProfile.CodingKeys.posts)
        }
    }
    
    struct Refresh: Decodable {
        let accessToken: String
    }
    
    
    // MARK: - Post Model
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
            let container: KeyedDecodingContainer<ResponseModel.PostID.CodingKeys> = try decoder.container(keyedBy: ResponseModel.PostID.CodingKeys.self)
            self.postID = try container.decode(String.self, forKey: ResponseModel.PostID.CodingKeys.postID)
            self.productId = try container.decodeIfPresent(String.self, forKey: ResponseModel.PostID.CodingKeys.productId) ?? ""
            self.title = try container.decode(String.self, forKey: ResponseModel.PostID.CodingKeys.title)
            self.content = try container.decode(String.self, forKey: ResponseModel.PostID.CodingKeys.content)
            self.content1 = try container.decodeIfPresent(String.self, forKey: ResponseModel.PostID.CodingKeys.content1) ?? ""
            self.content2 = try container.decodeIfPresent(String.self, forKey: ResponseModel.PostID.CodingKeys.content2) ?? ""
            self.content3 = try container.decodeIfPresent(String.self, forKey: ResponseModel.PostID.CodingKeys.content3) ?? ""
            self.content4 = try container.decodeIfPresent(String.self, forKey: ResponseModel.PostID.CodingKeys.content4) ?? ""
            self.content5 = try container.decodeIfPresent(String.self, forKey: ResponseModel.PostID.CodingKeys.content5) ?? ""
            self.createdAt = try container.decode(String.self, forKey: ResponseModel.PostID.CodingKeys.createdAt)
            self.creator = try container.decode(ResponseModel.PostID.Creator.self, forKey: ResponseModel.PostID.CodingKeys.creator)
            self.files = try container.decode([String].self, forKey: ResponseModel.PostID.CodingKeys.files)
            self.likes = try container.decode([String].self, forKey: ResponseModel.PostID.CodingKeys.likes)
            self.hashTags = try container.decode([String].self, forKey: ResponseModel.PostID.CodingKeys.hashTags)
            self.comments = try container.decode([ResponseModel.PostID.Comments].self, forKey: ResponseModel.PostID.CodingKeys.comments)
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
                let container: KeyedDecodingContainer<ResponseModel.PostID.Creator.CodingKeys> = try decoder.container(keyedBy: ResponseModel.PostID.Creator.CodingKeys.self)
                self.userID = try container.decode(String.self, forKey: ResponseModel.PostID.Creator.CodingKeys.userID)
                self.nick = try container.decode(String.self, forKey: ResponseModel.PostID.Creator.CodingKeys.nick)
                self.profileImage = try container.decodeIfPresent(String.self, forKey: ResponseModel.PostID.Creator.CodingKeys.profileImage) ?? ""
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
    
    
    // MARK: - Error Model
    struct ErrorMessage: Decodable {
        let message: String
    }
}
