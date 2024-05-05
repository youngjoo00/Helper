//
//  NoNetworkView.swift
//  Helper
//
//  Created by youngjoo on 5/5/24.
//

import UIKit
import Then

final class NoNetworkView: BaseView {
    
    let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .center
    }
    
    private let networkImageView = UIImageView().then {
        $0.image = UIImage(systemName: "wifi.slash")
        $0.backgroundColor = .clear
        $0.tintColor = Color.point
    }
    private let messageLabel = PointBoldLabel("인터넷 연결을 확인해주세요!", fontSize: 30, alignment: .center)
    
    override func configureHierarchy() {
        [
            verticalStackView,
        ].forEach { addSubview($0) }
        
        [
            networkImageView,
            messageLabel,
        ].forEach { verticalStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        verticalStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        networkImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func configureView() {
        backgroundColor = Color.white
    }
}
