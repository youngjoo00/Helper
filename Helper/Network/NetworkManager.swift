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
                        print("확인합니다")
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
                                    single(.success(.fail(.serverError(response))))
                                    print("서버 에러 메세지: ", response)
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
    
    func imageUpload<T: Decodable, U: TargetType>(type: T.Type, router: U, imageDataList: [Data]) -> Single<APIResult<T>> {
        return Single.create { single in
            do {
                let urlRequest = try router.asURLRequest()
                print(urlRequest)
                guard let url = urlRequest.url else {
                    single(.success(.fail(.invalidURL)))
                    return Disposables.create()
                }
                
                AF.upload(multipartFormData: { multipartFormData in
                    for data in imageDataList {
                        multipartFormData.append(data,
                                                 withName: "files",
                                                 fileName: "helper.png",
                                                 mimeType: "image/png")
                    }
                }, to: url, headers: urlRequest.headers, interceptor: TokenIntercepter())
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
                                single(.success(.fail(.serverError(response))))
                                print("서버 에러 메세지: ", response)
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
