//
//  String+.swift
//  Helper
//
//  Created by youngjoo on 4/19/24.
//

import Foundation

extension String {
    var checkedUserID: Bool {
        return self == UserDefaultsManager.shared.getUserID() ? true : false
    }
}
