//
//  ChatTableViewCell.swift
//  Helper
//
//  Created by youngjoo on 5/30/24.
//

import UIKit
import Then

final class ChatTableViewCell: BaseTableViewCell {
    
    private let profileButton = ImageButton(image: UIImage(systemName: "star"))
    private let nicknameLabel = PointLabel(fontSize: 13)
    private let chatLabel = PointLabel(fontSize: 15)
    private let timeLabel = PointLabel(fontSize: 12)
    
    override func configureHierarchy() {
        [
            profileButton,
            nicknameLabel,
            chatLabel,
            timeLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        profileButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.size.equalTo(33)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileButton)
            make.leading.equalTo(profileButton.snp.trailing).offset(3)
        }
        
        chatLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(3)
            make.leading.equalTo(nicknameLabel)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(chatLabel.snp.trailing).offset(3)
            make.bottom.equalTo(chatLabel.snp.bottom)
        }
    }
    
    override func configureView() {
        
    }
}
