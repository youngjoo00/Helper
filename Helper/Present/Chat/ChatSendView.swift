//
//  ChatSendView.swift
//  Helper
//
//  Created by youngjoo on 5/31/24.
//

import UIKit
import Then

final class ChatSendView: BaseView {
    
    let galleryButton = ImageButton(image: UIImage(systemName: "photo"))
    let chatTextView = PointTextView()
    let sendButton = ImageButton(image: UIImage(systemName: "paperplane"))
    
    override func configureHierarchy() {
        [
            galleryButton,
            chatTextView,
            sendButton
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        galleryButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(8)
            make.size.equalTo(40)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().inset(8)
            make.size.equalTo(40)
        }
        
        chatTextView.snp.makeConstraints { make in
            make.leading.equalTo(galleryButton.snp.trailing).offset(8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(40)
        }
    }
    
    override func configureView() {
        backgroundColor = .systemGray5
    }
}

extension ChatSendView {
    
    func adjustTextViewHeight() {
        let maxHeight: CGFloat = 100.0
        
        // sizeThatFits를 사용하여 실제 필요한 높이 계산
        let fittingSize = chatTextView.sizeThatFits(CGSize(width: chatTextView.bounds.width, height: CGFloat.infinity))
        let currentHeight = max(44.0, fittingSize.height)
        
        if currentHeight <= maxHeight {
            // 최대 높이 이하일 경우
            chatTextView.snp.updateConstraints { make in
                make.height.equalTo(currentHeight)
            }
            chatTextView.isScrollEnabled = false // 스크롤 비활성화
        } else {
            // 최대 높이를 초과할 경우
            chatTextView.snp.updateConstraints { make in
                make.height.equalTo(maxHeight)
            }
            chatTextView.isScrollEnabled = true // 스크롤 활성화
        }
        
        chatTextView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        // 레이아웃 업데이트
        self.layoutIfNeeded()
    }
    
}
