//
//  NetworkPathMonitor.swift
//  Helper
//
//  Created by youngjoo on 5/5/24.
//

import Foundation
import Network

final class NetworkMonitorManager {
    static let shared = NetworkMonitorManager()
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    private var isFirstConnection = true
    
    private init() {
        monitor = NWPathMonitor()
        dump(monitor)
        print("------------")
    }
    
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        var lastStatus: NWPath.Status?
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            // 상태가 마지막으로 보고된 상태와 동일하면 업데이트를 무시합니다.
            guard lastStatus != path.status else { return }
            lastStatus = path.status
            
            DispatchQueue.main.async {
                statusUpdateHandler(path.status)
                
                if path.status == .satisfied {
                    print("연결")
                    // 앱을 시작하면 무조건 연결이 되고 시작하기에, 첫 번째 연결 시에는 알림을 보내지 않음
                    if !self.isFirstConnection {
                        NotificationCenter.default.post(name: .networkReconnection, object: nil)
                    }
                    self.isFirstConnection = false
                } else {
                    print("해제")
                    self.isFirstConnection = false
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
