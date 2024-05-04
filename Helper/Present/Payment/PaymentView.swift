//
//  PaymentView.swift
//  Helper
//
//  Created by youngjoo on 5/4/24.
//

import UIKit
import Then
import WebKit

final class PaymentView: BaseView {
    
    let wkWebView = WKWebView().then {
        $0.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        addSubview(wkWebView)
    }
    
    override func configureLayout() {
        wkWebView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}
