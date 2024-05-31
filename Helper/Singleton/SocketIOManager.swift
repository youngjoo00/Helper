////
////  SocketIOManager.swift
////  Helper
////
////  Created by youngjoo on 5/31/24.
////
//
//import Foundation
//import SocketIO
//
//final class SocketIOManager {
//    
//    static let shared = SocketIOManager()
//    
//    var manager: SocketManager!
//    var socket: SocketIOClient!
//    
//    let baseURL = URL(string: PrivateKey.baseURL.rawValue + "/v1")!
//    var roomID = "/chats-\()"
//        
//    private init() {
//        manager = SocketManager(
//            socketURL: baseURL, // url
//            config: [.log(true), .compress] // log
//        )
//        
//        // forNamespace: roomID
//        socket = manager.socket(forNamespace: roomID)
//        
//        // 어떤 이벤트가 들어오는지 확인하는 메서드
//        socket.on(clientEvent: .connect) { data, ack in
//            print("socket conneted")
//        }
//        
//        socket.on(clientEvent: .disconnect) { data, ack in
//            print("socket disconneted")
//        }
//        
//        // 서버에서 전달받는 chat 데이터
//        // 서버와의 약속 "chat"
//        socket.on("chat") { dataArray, ack in
//            print("chat received", dataArray)
//            
//            // data: [Any] -> Data -> Struct
//            // JSONSerialization.data(withJSONObject: <#T##Any#>) 사용해서 data 타입으로 변환
//            
//            if let data = dataArray.first {
//                
//                do {
//                    let result = try JSONSerialization.data(withJSONObject: data)
//                    let decodedData = try JSONDecoder().decode(RealChat.self, from: result)
//                    
//                    self.receivedChatData.send(decodedData)
//                } catch {
//                    print(error)
//                }
//            }
//
//        }
//    }
//    
//    // MARK: - 요청을 반드시 먼저해서 통로를 열고 닫으세요
//    func establishConnection() {
//        socket.connect() // 연결 요청
//    }
//    
//    func leaveConnection() {
//        socket.disconnect() // 해제 요청
//    }
//}
