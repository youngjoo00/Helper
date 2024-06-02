//
//  ChatRoomView.swift
//  Helper
//
//  Created by youngjoo on 6/2/24.
//

import UIKit
import Then

final class ChatRoomView: BaseView {
    
    let testLabel = PointLabel("gd", fontSize: 30)
    
    override func configureHierarchy() {
        [
            testLabel
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}
