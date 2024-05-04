//
//  PymentRequest.swift
//  Helper
//
//  Created by youngjoo on 5/4/24.
//

enum PaymentRequest {
    struct Validation: Encodable {
        let impUID: String
        let postID: String
        let productName: String
        let price: Int
        
        enum CodingKeys: String, CodingKey {
            case impUID = "imp_uid"
            case postID = "post_id"
            case productName
            case price
        }
    }
}

