//
//  DateManager.swift
//  ReadingHaracoon
//
//  Created by youngjoo on 3/18/24.
//

import Foundation
import Then

final class DateManager {
    
    enum QueryType {
        case today
        case expected
    }
    
    static let shared = DateManager()
    
    private init() { }
    
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yyyy-MM-dd"
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    /// QueryType 을 매개변수로 받고, 원하는 case 의 함수를 호출해서 NSPredicate 값을 리턴합니다.
    func query(queryType: QueryType, date: Date) -> NSPredicate {
        switch queryType {
        case .today:
            todayQuery(date: date)
        case .expected:
            expectedQuery(date: date)
        }
    }
    
    func formatDateString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    /// 입력받은 날짜가 생년월일의 조건과 부합한지 확인
    func validationDate(year: Int, month: Int, day: Int) -> Bool {
        let calendar = Calendar.current
        let today = Date()
        
        // 입력한 날짜 생성
        guard let inputDate = calendar.date(from: DateComponents(year: year, month: month, day: day)),
              let startYear = calendar.date(from: DateComponents(year: year - 150, month: 1, day: 1)) else { return false }
        
        // 입력한 날짜가 오늘 날짜 이하면서, 150년 이내인지 확인
        if !(inputDate <= today && inputDate >= startYear) { return false }
        
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
}

// MARK: - Private
extension DateManager {

    private func startOfToday(date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    private func startOfTomorrow(date: Date) -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: startOfToday(date: date)) ?? Date()
    }
    
    private func todayQuery(date: Date) -> NSPredicate {
        let predicate = NSPredicate(format: "readingDate >= %@ && readingDate < %@", startOfToday(date: date) as NSDate, startOfTomorrow(date: date) as NSDate)
        
        return predicate
    }	
    
    // 미래에 읽을 예정인 책을 위해 남겨둠
    private func expectedQuery(date: Date) -> NSPredicate {
        let predicate = NSPredicate(format: "readingDate >= %@", startOfTomorrow(date: date) as NSDate)
        
        return predicate
    }
}
