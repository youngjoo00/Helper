//
//  PaymentRouter.swift
//  Helper
//
//  Created by youngjoo on 5/4/24.
//

import Foundation
import Alamofire

enum PaymentRouter {
    case validation(query: PaymentRequest.Validation)
    case paymentList
}

extension PaymentRouter: TargetType {
    var baseURL: String {
        PrivateKey.baseURL.rawValue
    }
    
    var header: [String : String] {
        let baseHeader = [
            HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
            HTTPHeader.sesacKey.rawValue: PrivateKey.sesac.rawValue
        ]
        switch self {
        case .validation, .paymentList:
            return baseHeader
        }
    }
    
    var path: String {
        let version = PathVersion.v1.rawValue
        switch self {
        case .validation:
            return version + "/payments" + "/validation"
        case .paymentList:
            return version + "/payments" + "/me"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .validation:
            return .post
        case .paymentList:
            return .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var parameters: String? {
        nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .validation(let query):
            return try? encoder.encode(query)
        case .paymentList:
            return nil
        }
    }
    
}
