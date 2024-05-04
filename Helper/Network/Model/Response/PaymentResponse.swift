//
//  PaymentResponse.swift
//  Helper
//
//  Created by youngjoo on 5/4/24.
//

import Foundation

enum PaymentResponse {
    struct PaymentList: Decodable {
        let data: [PaymentData]
    }
    
    struct PaymentData: Decodable {
        let paymentID: String
        let buyerID: String
        let postID: String
        let merchantUID: String
        let productName: String
        let price: Int
        let paidAt: String
        
        enum CodingKeys: String, CodingKey {
            case paymentID = "payment_id"
            case buyerID = "buyer_id"
            case postID = "post_id"
            case merchantUID = "merchant_uid"
            case productName
            case price
            case paidAt
        }
    }
}
