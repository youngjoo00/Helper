//
//  TokenIntercepter.swift
//  LSLPBasic
//
//  Created by youngjoo on 4/12/24.
//

import Alamofire
import Foundation
import RxSwift

final class TokenIntercepter: RequestInterceptor {
    
    let disposeBag = DisposeBag()
    
    // 1. 통신직전 가로채서 토큰 값을 넣고 통신을 진행함
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        print(#function)
        var urlRequest = urlRequest
        let accessToken = UserDefaultsManager.shared.getAccessToken()
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        
        completion(.success(urlRequest))
    }
    
    // 2. 근데 419 에러 떴어?? -> 그럼 토큰 갱신
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let statusCode: Int = request.response?.statusCode ?? 0
        print(#function, statusCode)
        if statusCode == 419 {
            refreshToken { isSuccess in
                if isSuccess {
                    completion(.retry)
                } else {
                    completion(.doNotRetry)
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }

    // 3. 근데 토큰 갱신하다가 418 에러 떴어? -> 그럼 리프레시 토큰도 만료되어서 로그인부터 다시하라는 오류 메세지 전달
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        print(#function)
        do {
            let urlRequest = try UserRouter.refresh.asURLRequest()
            AF.request(urlRequest)
                .responseDecodable(of: UserResponse.Refresh.self) { response in
                    switch response.result {
                    case .success(let data):
                        UserDefaultsManager.shared.saveToken(data.accessToken)
                        completion(true)
                    case .failure(let fail):
                        if response.response?.statusCode == 418 {
                            print("로그인부터 다시 하세요")
                        } else {
                            print(fail)
                        }
                        completion(false)
                    }
                }
        } catch {
            print(error)
            completion(false)
        }
    }
}
