//
//  ChatRoomTableViewCell.swift
//  Helper
//
//  Created by youngjoo on 6/2/24.
//

import UIKit
import Then

final class ChatRoomTableViewCell: BaseTableViewCell {
    
    private let profileImageView = ProfileImageView()
    private let nicknameLabel = PointLabel(fontSize: 15)
    private let lastChatLabel = PointLabel(fontSize: 13)
    private let timeLabel = PointLabel(fontSize: 12)
    
    override func configureHierarchy() {
        [
            profileImageView,
            nicknameLabel,
            lastChatLabel,
            timeLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(5)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
        }
        
        lastChatLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nicknameLabel)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    override func configureView() {
        
    }
}

extension ChatRoomTableViewCell {
    
    func updateView(_ item: ChatResponse.RoomData) {
        let otherUser = item.participants[1]
        profileImageView.updateImage(otherUser.profileImage)
        nicknameLabel.text = otherUser.nick
        lastChatLabel.text = item.lastChat.content
        timeLabel.text = DateManager.shared.dateFormat(item.lastChat.createdAt)
    }
}
