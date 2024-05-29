//
//  ChatViewController.swift
//  Helper
//
//  Created by youngjoo on 5/29/24.
//

import UIKit
import RxSwift

final class ChatViewController: BaseViewController {
    
    private let mainView = ChatView()
    private let chatViewModel = ChatViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        
    }
}
