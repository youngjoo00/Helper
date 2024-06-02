//
//  ChatRoomView.swift
//  Helper
//
//  Created by youngjoo on 6/2/24.
//

import UIKit
import Then

final class ChatRoomView: BaseView {
        
    let chatRoomTableView = BaseTableView().then {
        $0.register(ChatRoomTableViewCell.self, forCellReuseIdentifier: ChatRoomTableViewCell.id)
        $0.separatorStyle = .none
        $0.rowHeight = 60
    }
    
    override func configureHierarchy() {
        [
            chatRoomTableView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        chatRoomTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        
    }
}
