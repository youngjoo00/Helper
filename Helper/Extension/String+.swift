//
//  String+.swift
//  Helper
//
//  Created by youngjoo on 4/19/24.
//

import Foundation

extension String {
    /// 현재 ID 와 동일한지 확인
    var checkedUserID: Bool {
        return self == UserDefaultsManager.shared.getUserID() ? true : false
    }
    
    /// [0] = region, [1] = category
    var splitProductID: [String] {
        return self.split(separator: "_").map { String($0) }
    }
    
    /// 콘텐츠가 비어있으면 없음 이라는 String 반환
    var contentEmpty: String {
        return self.isEmpty ? "없음" : self
    }
}
