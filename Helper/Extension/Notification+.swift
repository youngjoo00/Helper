//
//  Notification+.swift
//  Helper
//
//  Created by youngjoo on 4/28/24.
//

import Foundation

extension Notification.Name {
    static let loginSessionExpired = Notification.Name("loginSessionExpiredNotification")
    static let unknownError = Notification.Name("unknownError")
    static let networkReconnection = Notification.Name("networkReconnection")
}
