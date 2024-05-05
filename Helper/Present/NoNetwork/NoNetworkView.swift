//
//  NoNetworkView.swift
//  Helper
//
//  Created by youngjoo on 5/5/24.
//

import UIKit
import Then

final class NoNetworkView: UIView {
    
    private let messageLabel = PointBoldLabel("인터넷 연결을 확인해주세요!", fontSize: 30, alignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(messageLabel)
    }
    
    private func setupLayout() {
        messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.greaterThanOrEqualToSuperview().inset(16)
        }
    }

}
