//
//  PostRequest.swift
//  Helper
//
//  Created by youngjoo on 4/17/24.
//

import Foundation

enum PostRequest {
    
    struct FetchHashTag {
        let next: String
        let productID: String
        let hashTag: String
        
        enum CodingKeys: String, CodingKey {
            case next
            case limit
            case productID = "product_id"
            case hashTag
        }
    }
    
    struct Write: Encodable {
        let title: String
        let hashTag: String
        let feature: String
        let locate: String
        let date: String
        let phone: String
        let content: String
        let product_id: String
        let files: [String]
        
        enum CodingKeys: String, CodingKey {
            case title
            case hashTag = "content"
            case feature = "content1"
            case locate = "content2"
            case date = "content3"
            case phone = "content4"
            case content = "content5"
            case product_id
            case files
        }
    }
    
//    struct Feed: Encodable {
//        let title: String
//        let hashTag: String
//        let product_id: String
//        let files: [String]
//        
//        enum CodingKeys: String, CodingKey {
//            case title
//            case hashTag = "content"
//            case product_id
//            case files
//        }
//    }
    
    struct StorageStatus: Encodable {
        let storageStatus: Bool
        
        enum CodingKeys: String, CodingKey {
            case storageStatus = "like_status"
        }
    }
    
}
