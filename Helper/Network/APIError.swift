//
//  APIError.swift
//  LSLPBasic
//
//  Created by youngjoo on 4/10/24.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
    case decodingFali
    case noData
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL 입니다."
        case .unknownResponse:
            return "알 수 없는 응답입니다."
        case .statusError:
            return "상태 에러가 발생했습니다."
        case .decodingFali:
            return "디코딩에 실패했습니다."
        case .noData:
            return "데이터가 없습니다."
        }
    }
}
