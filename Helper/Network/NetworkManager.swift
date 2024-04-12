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
    case errorMessage(ResponseModel.ErrorMessage)
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func callAPI<T: Decodable>(type: T.Type, router: UserRouter) -> Single<APIResult<T>> {
        return Single.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                AF.request(urlRequest, interceptor: TokenIntercepter())
                    .validate(statusCode: 200..<300)
                    .responseData { response in
                        switch response.result {
                        case .success(let data):
                            do {
                                let response = try JSONDecoder().decode(type, from: data)
                                single(.success(.success(response)))
                            } catch {
                                single(.success(.fail(.decodingFali)))
                            }
                        case .failure:
                            if let data = response.data {
                                do {
                                    let response = try JSONDecoder().decode(ResponseModel.ErrorMessage.self, from: data)
                                    single(.success(.errorMessage(response)))
                                } catch {
                                    single(.success(.fail(.decodingFali)))
                                }
                            }
                        }
                    }
            } catch {
                single(.success(.fail(.invalidURL)))
            }
            
            return Disposables.create()
        }
    }
}
