//
//  NumberManager.swift
//  Helper
//
//  Created by youngjoo on 5/5/24.
//

import Foundation
import Then

final class NumberManager {
    
    static let shared = NumberManager()
    
    private init() { }
    
    private let numberFormatter = NumberFormatter().then {
        $0.numberStyle = .decimal
    }
    
    // 숫자를 문자열로 변환 (콤마 포함)
    func stringFromNumber(_ number: Int) -> String? {
        return numberFormatter.string(for: number)
    }
    
    // 문자열에서 공백과 콤마를 제거하고 숫자로 변환
    func numberFromString(_ string: String) -> NSNumber? {
        let cleanedString = string.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: "")
        return numberFormatter.number(from: cleanedString)
    }
}
