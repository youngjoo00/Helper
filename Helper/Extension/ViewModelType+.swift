//
//  ViewModelType+.swift
//  Helper
//
//  Created by youngjoo on 4/13/24.
//

import Foundation

extension ViewModelType {
    
    // 이메일 정규성 체크
    func validateEmail(_ input: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: input)

        return isValid
    }
    
    // phone 정규성 체크
    func validatePhone(_ input: String) -> Bool {
        let regex = "^01[0-1, 7][0-9]{7,8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: input)

        return isValid
    }
}
