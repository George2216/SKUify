//
//  Date.swift
//  SKUify
//
//  Created by George Churikov on 12.01.2024.
//

import Foundation

class DateHelper {

    static let shared = DateHelper()

    lazy var calendar: Calendar = {
        var cal = Calendar(identifier: .iso8601)
        cal.locale = Locale.current
        cal.timeZone = TimeZone.current
        return cal
    }()
}

extension Date {
    func isEqual(
        date: Date = Date(),
        toGranularity: Calendar.Component = .day
    ) -> Bool {
        let calendar = DateHelper.shared.calendar
        let ordered = calendar.compare(date, to: self, toGranularity: toGranularity)
        return ordered == .orderedSame
    }
}

extension Date {
    func yyyyMMddString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
}
