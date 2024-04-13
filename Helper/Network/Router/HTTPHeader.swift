//
//  HTTPHeader.swift
//  LSLPBasic
//
//  Created by youngjoo on 4/10/24.
//

import Foundation

enum HTTPHeader: String {
    case authorization = "Authorization"
    case sesacKey = "SesacKey"
    case refresh = "Refresh"
    case contentType = "Content-Type"
    case json = "application/json"
    case multipart = "multipart/form-data"
}
