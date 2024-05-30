//
//  ChatViewModel.swift
//  Helper
//
//  Created by youngjoo on 5/29/24.
//

import RxSwift
import RxCocoa

final class ChatViewModel: ViewModelType {

    var disposeBag = DisposeBag()
    var userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    
    struct Input {
        let viewWillAppearTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let chatDataList: Driver<[ChatResponse.ChatData]>
    }
    
    func transform(input: Input) -> Output {
        
        let chatListRequest = PublishSubject<(String)>()
        
        let chatDataList = PublishSubject<[ChatResponse.ChatData]>()
        
        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { _ in NetworkManager.shared.callAPI(type: ChatResponse.CreateRoom.self, router: Router.chat(.createRoom(query: .init(opponentID: self.userID)))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    chatListRequest.onNext((data.roomID))
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        chatListRequest
            .flatMap { NetworkManager.shared.callAPI(type: ChatResponse.ChatList.self, router: Router.chat(.chatList(roomID: $0, query: ChatRequest.ChatList(cursorDate: ""))))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    chatDataList.onNext(data.data)
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            chatDataList: chatDataList.asDriver(onErrorDriveWith: .empty())
        )
    }
    
}
