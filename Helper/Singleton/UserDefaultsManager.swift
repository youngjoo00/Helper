//
//  UserDefaultsManager.swift
//  LSLPBasic
//
//  Created by youngjoo on 4/10/24.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    let userdefaults = UserDefaults.standard
    let tokenKey = "token"
    let refreshTokenKey = "refreshToken"
    let userIDKey = "userID"
    let profileKey = "profile"
    
    func saveTokens(_ token: String, refreshToken: String) {
        userdefaults.setValue(token, forKey: tokenKey)
        userdefaults.setValue(refreshToken, forKey: refreshTokenKey)
    }
    
    func saveToken(_ token: String) {
        userdefaults.setValue(token, forKey: tokenKey)
    }
    
    func getAccessToken() -> String {
        return userdefaults.string(forKey: tokenKey) ?? ""
    }
    
    func getRefreshToken() -> String {
        return userdefaults.string(forKey: refreshTokenKey) ?? ""
    }
    
    func saveUserID(_ id: String) {
        userdefaults.setValue(id, forKey: userIDKey)
    }
    
    func getUserID() -> String {
        return userdefaults.string(forKey: userIDKey) ?? ""
    }

}
