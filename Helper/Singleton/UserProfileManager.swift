//
//  SignUpManager.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation

final class UserProfileManager {
    
    static let shared = UserProfileManager()
    private init() {}
    
    var email: String = ""
    var password: String = ""
    var nick: String = ""
    var phone: String = ""
    var birthday: String = ""
}
