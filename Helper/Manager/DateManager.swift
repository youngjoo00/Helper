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
