//
//  ChatViewModel.swift
//  Helper
//
//  Created by youngjoo on 5/29/24.
//

import RxSwift
import RxCocoa
import RealmSwift

enum SocketState {
    case connect
    case disconnect
}

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
        let scrollToBottomTrigger: PublishSubject<Void>
    }
    
    struct Output {
        let chatDataList: Driver<[ChatRealm]>
        let sendSuccess: Driver<Void>
        let scrollToBottom: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let checkChatRoom = PublishSubject<Void>()
        let chatListRequest = PublishSubject<String>()
        let socket = PublishSubject<SocketState>()
        
        // MARK: - Output Property
        let chatDataList = PublishRelay<[ChatRealm]>()
        let sendSuccess = PublishRelay<Void>()
        
        // MARK: - bind
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
                    
                    chatDataList.accept(owner.chatRoomRepository.fetchChatAllList(owner.roomID))

                    socket.onNext(.connect)
                    input.scrollToBottomTrigger.onNext(())
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        socket
            .subscribe(with: self) { owner, state in
                switch state {
                case .connect:
                    SocketIOManager.shared.roomID = owner.roomID
                    SocketIOManager.shared.establishConnection()
                case .disconnect:
                    SocketIOManager.shared.roomID = ""
                    SocketIOManager.shared.leaveConnection()
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
                    let chatModel = owner.createChatModel(chatID: data.chatID,
                                    roomID: data.roomID,
                                    content: data.content,
                                    createdAt: data.createdAt,
                                    sender: data.sender,
                                    files: data.files)
                    
                    let result = owner.createChatItem(chatModel)
                    
                    if result {
                        chatDataList.accept(owner.chatRoomRepository.fetchChatAllList(owner.roomID))
                        sendSuccess.accept(())
                    } else {
                        print("실패")
                    }
                case .fail(let fail):
                    print(fail.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            chatDataList: chatDataList.asDriver(onErrorDriveWith: .empty()),
            sendSuccess: sendSuccess.asDriver(onErrorJustReturn: ()),
            scrollToBottom: input.scrollToBottomTrigger.asDriver(onErrorJustReturn: ())
        )
    }
    
}

extension ChatViewModel {
    
    private func createChatModel(chatID: String, roomID: String, content: String, createdAt: String, sender: ChatResponse.Sender, files: [String]) -> ChatRealm {
        let filesList = List<String>()
        filesList.append(objectsIn: files)

        return ChatRealm(
            chatID: chatID,
            roomID: roomID,
            content: content,
            createdAt: createdAt,
            sender: SenderRealm(userID: sender.userID,
                                nick: sender.nick,
                                profileImage: sender.profileImage),
            files: filesList
        )
    }
    
    private func createChatItem(_ chatModel: ChatRealm) -> Bool {
        do {
            try chatRepository.createChatItem(chatModel, roomID: roomID)
            return true
        } catch {
            print("생성 실패", error)
            return false
        }
    }
}
