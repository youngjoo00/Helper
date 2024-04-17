//
//  UserRequest.swift
//  Helper
//
//  Created by youngjoo on 4/17/24.
//

import Foundation

enum UserRequest {
    struct Join: Encodable {
        let email: String
        let password: String
        let nick: String
        let phoneNum: String
        let birthDay: String
    }

    struct Login: Encodable {
        let email: String
        let password: String
    }

    struct ValidationEmail: Encodable {
        let email: String
    }
}

