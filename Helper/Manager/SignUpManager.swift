//
//  SignUpManager.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation

final class SignUpManager {
    
    static let shared = SignUpManager()
    private init() {}
    
    var email: String = ""
    var password: String = ""
    var nick: String = ""
    var phone: String = ""
    var birthday: String = ""
}
