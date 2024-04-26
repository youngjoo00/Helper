//
//  UIImageView.swift
//  Helper
//
//  Created by youngjoo on 4/15/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    /// Kingfisher 를 이용한 이미지 로드
    func loadImage(urlString: String) {
        let url = urlString.isEmpty ? HelperString.blankProfileImage : urlString
        
        do {
            let urlRequest = try Router.post(.image(url: url)).asURLRequest()
            
            let modifier = AnyModifier { _ in
                return urlRequest
            }
        
            self.kf.indicatorType = .activity
            
            self.kf.setImage(
                with: urlRequest.url,
                placeholder: nil,
                options: [.requestModifier(modifier)]) { response in
                    switch response {
                    case .success:
                        return
                    case .failure(let error):
                        if case .responseError(reason: let reason) = error {
                            switch reason {
                            case .invalidURLResponse(response: let response):
                                print("invalidURLResponse", response)
                            case .invalidHTTPStatusCode(response: let response):
                                print("invalidHTTPStatusCode", response.statusCode)
                            case .URLSessionError(error: let error):
                                print("URLSessionError", error)
                            case .dataModifyingFailed(task: let task):
                                print("dataModifyingFailed", task)
                            case .noURLResponse(task: let task):
                                print("noURLResponse", task)
                            case .cancelledByDelegate(response: let response):
                                print("cancelledByDelegate", response)
                            }
                        }
                    }
                }
        } catch {
            print("loadImage: ", error)
        }
    }
}


