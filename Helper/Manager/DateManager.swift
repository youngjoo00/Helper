//
//  DateManager.swift
//  ReadingHaracoon
//
//  Created by youngjoo on 3/18/24.
//

import Foundation
import Then

final class DateManager {
    
    static let shared = DateManager()
    
    private init() { }
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    /// date 를 String 으로
    func formatDateToString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    /// 입력받은 날짜가 생년월일의 조건과 부합한지 확인
    func validationDate(year: Int, month: Int, day: Int) -> Bool {
        let calendar = Calendar.current
        
        let today = Date()
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
        
        // 입력한 날짜 생성 + 연도를 뺄셈하기 위해 연도 값 반환
        guard let inputDate = calendar.date(from: DateComponents(year: year, month: month, day: day)),
              let nowYear = todayComponents.year else { return false }
        
        // 뺄셈 이후 다시 비교하기 위해 Date 로 변환
        let ableYear = nowYear - 150
        guard let ableDate = calendar.date(from: DateComponents(year: ableYear, month: 1, day: 1)) else { return false }
        
        // 입력한 날짜가 오늘 날짜 이하면서, 150년 이내인지 확인
        guard (inputDate <= today && inputDate >= ableDate) else { return false }
        
        // 월 범위 확인
        guard month >= 1, month <= 12 else { return false }
        
        // 달의 마지막날 구하기
        // 1. 다음달 0일로 설정
        let components = DateComponents(year: year, month: month + 1, day: 0)
        
        // 2. date 로 변경하면 day 가 0일 경우, 하루 전 날짜를 얻어냄
        guard let lastDayOfMonth = calendar.date(from: components) else { return false }
        
        // 3. 그걸 다시 component 를 이용해서 달의 마지막 날짜를 구한다.
        let lastDay = calendar.component(.day, from: lastDayOfMonth)
        
        // 입력한 day 가 해당 달의 마지막 날짜 이하인지 확인
        guard day >= 1, day <= lastDay else { return false }
        
        return true
    }
    
    /// 서버에서 받은 날짜를 우리가 사용하도록
    func dateFormat(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let displayFormatter = DateFormatter()
        displayFormatter.locale = Locale(identifier: "ko_KR")
        
        guard let inputDate = dateFormatter.date(from: dateString) else {
            return "잘못된 날짜 형식"
        }
        
        let today = Date()
        let second = today.timeIntervalSince(inputDate)
        
        // dateString 이 오늘로부터 1시간 미만으로 작성되었다면, 1분 전, 59분 전 이런 형식으로 리턴
        // 혹은 1~23시간59분59초 사이에 작성됐다면 1시간 전, 10시간 전 23시간 전 이런 형식으로 리턴
        // 24시간 이상이라면 yyyy-MM-dd 형식으로 리턴
        
        if second < 3600 {
            let minute = max(1, Int(second / 60))
            return "\(minute)분 전"
        } else if second < 86400 {
            let hour = Int(second / 3600)
            return "\(hour)시간 전"
        } else {
            displayFormatter.dateFormat = "yyyy-MM-dd"
            return displayFormatter.string(from: inputDate)
        }

    }
    
    func formatStringToDate(_ dateString: String) -> Date {
        return dateFormatter.date(from: dateString) ?? Date()
    }
}


