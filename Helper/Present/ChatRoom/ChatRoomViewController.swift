//
//  ChatRoomViewController.swift
//  Helper
//
//  Created by youngjoo on 6/2/24.
//

import UIKit

final class ChatRoomViewController: BaseViewController {
    
    private let mainView = ChatRoomView()
    private let chatRoomViewModel = ChatRoomViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
