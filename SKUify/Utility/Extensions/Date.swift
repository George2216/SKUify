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
    func yyyyMMddString(_ separator: String = "-") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy\(separator)MM\(separator)dd"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    func mmddyyyyString(_ separator: String = "-") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM\(separator)dd\(separator)yyyy"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    func ddMMyyyyString(_ separator: String = "-") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd\(separator)MM\(separator)yyyy"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    func ddMMMMyyyyString(_ separator: String = "-") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd\(separator)MMMM\(separator)yyyy"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }

    func yyyyMMddTHHmmssString(_ separator: String = "-") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy\(separator)MM\(separator)dd'T'HH:mm:ss"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    func yyyyMMddTHHmmString(_ separator: String = "-") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy\(separator)MM\(separator)dd'T'HH:mm"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    func ddMMyyhmma(_ separator: String = "-") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd\(separator)MM\(separator)yy h:mma"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
    func hmma() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        let formattedDate = dateFormatter.string(from: self)
        return formattedDate
    }
    
}
