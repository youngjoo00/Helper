//
//  ChatViewModel.swift
//  Helper
//
//  Created by youngjoo on 5/29/24.
//

import RxSwift
import RxCocoa
import RealmSwift

final class ChatViewModel: ViewModelType {

    var chatRoomRepository: ChatRoomRepository
    var chatRepository: ChatRepository
    var disposeBag = DisposeBag()

    var userID: String
    var roomID = ""

    init(userID: String) {
        self.userID = userID
        self.chatRoomRepository = ChatRoomRepository()
        self.chatRepository = ChatRepository()
    }
    
    struct Input {
        let viewWillAppearTrigger: ControlEvent<Void>
        let chatText: Observable<String>
        let chatSendTapped: ControlEvent<Void>
        let galleryButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let chatDataList: Driver<[ChatRealm]>
    }
    
    func transform(input: Input) -> Output {
        
        let checkChatRoom = PublishSubject<Void>()
        let chatListRequest = PublishSubject<String>()
        let chatDataList = PublishSubject<[ChatRealm]>()
        
        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { _ in NetworkManager.shared.callAPI(type: ChatResponse.CreateRoom.self, router: Router.chat(.createRoom(query: .init(opponentID: self.userID)))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    owner.roomID = data.roomID
                    checkChatRoom.onNext(())
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
  
        checkChatRoom
            .subscribe(with: self) { owner, _ in
                do {
                    try owner.chatRoomRepository.createChatRoomIfNeeded(roomID: owner.roomID)
                } catch {
                    print("create 실패", error)
                }
                
                let lastCreatedAt = owner.chatRoomRepository.fetchChatLastCreatedAt(owner.roomID)
                if lastCreatedAt.isEmpty {
                    print("새로운 채팅방이 생성되었습니다. 채팅을 시작해보세요")
                } else {
                    print("마지막 채팅 날짜: \(lastCreatedAt)")
                }
                
                chatListRequest.onNext(lastCreatedAt)
            }
            .disposed(by: disposeBag)
        
        chatListRequest
            .withUnretained(self)
            .flatMap { owner, cursorDate in
                NetworkManager.shared.callAPI(type: ChatResponse.ChatList.self, router: Router.chat(.chatList(roomID: owner.roomID, query: ChatRequest.ChatList(cursorDate: cursorDate))))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    data.data.forEach { chat in
                        let files = List<String>()
                        files.append(objectsIn: chat.files)
                        
                        let chatModel = ChatRealm(chatID: chat.chatID,
                                  roomID: chat.roomID,
                                  content: chat.content,
                                  createdAt: chat.createdAt,
                                  sender: SenderRealm(userID: chat.sender.userID,
                                                      nick: chat.sender.nick,
                                                      profileImage: chat.sender.profileImage),
                                  files: files)
                        
                        do {
                            try owner.chatRepository.createChatItem(chatModel, roomID: owner.roomID)
                        } catch {
                            print("생성 실패!", error)
                        }
                    }
                    
                    chatDataList.onNext(owner.chatRoomRepository.fetchChatAllList(owner.roomID))
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.chatSendTapped
            .withLatestFrom(input.chatText)
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .flatMap { _, chat in
                NetworkManager.shared.callAPI(type: ChatResponse.Send.self, router: Router.chat(.send(roomID: self.roomID, query: ChatRequest.Send(content: chat, files: [])))) }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let data):
                    print(data)
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
