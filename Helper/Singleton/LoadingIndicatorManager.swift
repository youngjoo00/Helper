//
//  LoadingIndicatorManager.swift
//  Helper
//
//  Created by youngjoo on 5/3/24.
//

import UIKit

final class LoadingIndicatorManager {
    static let shared = LoadingIndicatorManager()
    private init() {}

    var indicator: UIActivityIndicatorView?

    func showIndicator() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.getWindow else { return }
            self.indicator?.removeFromSuperview() // 중복 생성 방지

            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = window.center
            indicator.startAnimating()
            window.addSubview(indicator)

            self.indicator = indicator
        }
    }

    func hideIndicator() {
        DispatchQueue.main.async {
            self.indicator?.stopAnimating()
            self.indicator?.removeFromSuperview()
        }
    }
}
