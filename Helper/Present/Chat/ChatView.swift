//
//  ChatView.swift
//  Helper
//
//  Created by youngjoo on 5/29/24.
//

import UIKit

final class ChatView: BaseView {
 
    private let navigationTitleLabel = PointLabel(fontSize: 18, alignment: .center)
    
    private let chatTableView = BaseTableView().then {
        $0.backgroundColor = .gray
    }
    
    override func configureHierarchy() {
        [
            chatTableView
        ].forEach { addSubview($0) }
    }
    
    override func configureLayout() {
        
    }
    
    override func configureView() {
        
    }
}
