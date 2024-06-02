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
    
    override func bind() {
        
        let input = ChatRoomViewModel.Input(
            viewWillAppearTrigger: self.rx.viewWillAppear
        )
        
        let output = chatRoomViewModel.transform(input: input)
        
        output.roomList
            .drive(mainView.chatRoomTableView.rx.items(cellIdentifier: ChatRoomTableViewCell.id,
                                                       cellType: ChatRoomTableViewCell.self)) { row, item, cell in
                cell.updateView(item)
            }
            .disposed(by: disposeBag)
    }
}
