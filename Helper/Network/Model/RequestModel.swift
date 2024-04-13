//
//  Querys.swift
//  LSLPBasic
//
//  Created by youngjoo on 4/10/24.
//

import Foundation

enum RequestModel {
    struct Join: Encodable {
        let email: String
        let password: String
        let nick: String
        let phone: String?
        let birthday: String?
    }

    struct Login: Encodable {
        let email: String
        let password: String
    }
    
    struct ValidationEmail: Encodable {
        let email: String
    }
}

