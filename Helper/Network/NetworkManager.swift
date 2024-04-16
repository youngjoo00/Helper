//
//  NetworkManager.swift
//  LSLPBasic
//
//  Created by youngjoo on 4/10/24.
//

import Foundation
import RxSwift
import Alamofire

enum APIResult<T: Decodable> {
    case success(T)
    case fail(APIError)
    case errorMessage(ErrorResponse.ErrorMessage)
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func callAPI<T: Decodable, U: TargetType>(type: T.Type, router: U) -> Single<APIResult<T>> {
        return Single.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                print(urlRequest)
                AF.request(urlRequest, interceptor: TokenIntercepter())
                    .validate(statusCode: 200..<300)
                    .responseData { response in
                        switch response.result {
                        case .success(let data):
                            do {
                                print("서버 통신 성공")
                                let response = try JSONDecoder().decode(type, from: data)
                                single(.success(.success(response)))
                            } catch {
                                print("서버 통신 성공 케이스: ", error)
                                single(.success(.fail(.decodingFali)))
                            }
                        case .failure:
                            if let data = response.data {
                                do {
                                    let response = try JSONDecoder().decode(ErrorResponse.ErrorMessage.self, from: data)
                                    single(.success(.errorMessage(response)))
                                } catch {
                                    print("서버 통신 실패 케이스: ", error)
                                    single(.success(.fail(.decodingFali)))
                                }
                            }
                        }
                    }
            } catch {
                print("URL 이슈: ", error)
                single(.success(.fail(.invalidURL)))
            }
            
            return Disposables.create()
        }
    }
}
