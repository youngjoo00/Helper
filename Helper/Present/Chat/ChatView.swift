//
//  ChatView.swift
//  Helper
//
//  Created by youngjoo on 5/29/24.
//

import UIKit
import Then

final class ChatView: BaseView {
 
    private let navigationTitleLabel = PointLabel(fontSize: 18, alignment: .center)
    
    let chatTableView = BaseTableView().then {
        $0.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.id)
    }
    
    private let chatSendView = ChatSendView()
    
    override func configureHierarchy() {
        [
            chatTableView,
            chatSendView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        chatTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        chatSendView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    override func configureView() {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        adjustChatSendViewLayoutForSafeArea()
    }
}

extension ChatView {
    
    private func adjustChatSendViewLayoutForSafeArea() {
        if safeAreaInsets.bottom == 0 {
            chatSendView.snp.makeConstraints { make in
                make.bottom.equalTo(safeAreaInsets).offset(-16)
            }
        } else {
            chatSendView.snp.makeConstraints { make in
                make.bottom.equalTo(safeAreaLayoutGuide)
            }
        }
    }
}
