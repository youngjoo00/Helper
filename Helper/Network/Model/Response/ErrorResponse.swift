//
//  ErrorResponse.swift
//  Helper
//
//  Created by youngjoo on 4/17/24.
//

import Foundation

enum ErrorResponse {
    struct ErrorMessage: Decodable {
        let message: String
    }
}
