//
//  String+.swift
//  Helper
//
//  Created by youngjoo on 4/19/24.
//

import UIKit

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
    
    /// 현재 ID 와 비교해서 프로필 VC 반환
    var checkedProfile: UIViewController {
        self.checkedUserID ? MyProfileViewController() : OtherProfileViewController(userID: self)
    }
    
    /// 폰 번호 형식에 맞게 반환
    var formattedPhoneNumber: String {
        let numbers = Array(self)
        var first: String
        var middle: String
        var last: String
        
        if numbers.count == 10 {
            first = String(numbers[0...2])
            middle = String(numbers[3...5])
            last = String(numbers[6...9])
        } else if numbers.count == 11 {
            first = String(numbers[0...2])
            middle = String(numbers[3...6])
            last = String(numbers[7...10])
        } else {
            return self
        }
        
        return "\(first)-\(middle)-\(last)"
    }
    
    /// 생년월일 형식에 맞게 반환, yyyy-MM-dd
    var formattedBirthDay: String {
        guard self.count == 8 else { return self }
        
        let numbers = Array(self)
        let year = String(numbers[0...3])
        let month = String(numbers[4...5])
        let day = String(numbers[6...7])
        
        return "\(year)-\(month)-\(day)"
    }
    
    /// 문자에 들어간 - 지우고 반환
    var removeHyphens: String {
        self.replacingOccurrences(of: "-", with: "")
    }
}
