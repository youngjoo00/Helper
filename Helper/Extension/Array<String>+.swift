//
//  Array<String>+.swift
//  Helper
//
//  Created by youngjoo on 4/29/24.
//

import Foundation

extension [String] {
    /// String 배열중에 현재 ID 와 동일한지 확인
    var listCheckedUserID: Bool {
        self.filter { $0.checkedUserID }.count >= 1
    }
}
