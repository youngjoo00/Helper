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
    private let chatViewModel: ChatViewModel
    
    init(userID: String) {
        chatViewModel = ChatViewModel(userID: userID)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func bind() {
        let input = ChatViewModel.Input(
            viewWillAppearTrigger: self.rx.viewWillAppear
        )
        
        let output = chatViewModel.transform(input: input)
    }
}
