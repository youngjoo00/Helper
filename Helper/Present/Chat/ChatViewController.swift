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
        
        let scrollToBottomTrigger = PublishSubject<Void>()
        
        let input = ChatViewModel.Input(
            viewWillAppearTrigger: self.rx.viewWillAppear,
            chatText: mainView.chatSendView.chatTextView.rx.text.orEmpty.asObservable(),
            chatSendTapped: mainView.chatSendView.sendButton.rx.tap,
            galleryButtonTapped: mainView.chatSendView.galleryButton.rx.tap,
            scrollToBottomTrigger: scrollToBottomTrigger
        )
        
        let output = chatViewModel.transform(input: input)
        
        output.chatDataList
            .drive(mainView.chatTableView.rx.items(cellIdentifier: ChatTableViewCell.id,
                                                   cellType: ChatTableViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
        
        output.sendSuccess
            .drive(with: self) { owner, _ in
                owner.mainView.chatSendView.chatTextView.text = ""
                scrollToBottomTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        output.scrollToBottom
            .drive(with: self) { owner, _ in
                owner.scrollToBottom()
            }
            .disposed(by: disposeBag)
    }
}

extension ChatViewController {
    
    private func scrollToBottom() {
        // numberOfSections, numberOfRows 는 0이 아닌 1부터 개수를 세기 때문에 -1 필요
        let numberOfSections = mainView.chatTableView.numberOfSections
        let numberOfRows = mainView.chatTableView.numberOfRows(inSection: numberOfSections - 1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
            mainView.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
}
