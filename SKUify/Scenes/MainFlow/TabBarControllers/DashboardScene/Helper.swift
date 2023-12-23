//
//  Helper.swift
//  SKUify
//
//  Created by George Churikov on 20.12.2023.
//

import Foundation

enum DashboardDataState: String {
    case today
    case yesterday
    case days7
    case days30
    case days90
    case days365
    case all
    case custom

    var title: String {
        switch self {
        case .today,
                .yesterday,
                .all,
                .custom:
            return rawValue.capitalized
        case .days7:
            return "7 Days"
        case .days30:
            return "30 Days"
        case .days90:
            return "90 Days"
        case .days365:
            return "365 Days"
        }
    }
    
    var startDate: String? {
        switch self {
        case .today:
            return formattedDate(for: .day, value: 0)
        case .yesterday:
            return formattedDate(for: .day, value: -1)
        case .days7:
            return formattedDate(for: .weekOfYear, value: -1)
        case .days30:
            return formattedDate(for: .month, value: -1)
        case .days90:
            return formattedDate(for: .day, value: -90)
        case .days365:
            return formattedDate(for: .year, value: -1)
        case .all, .custom:
            return nil
        }
    }
    
    private func formattedDate(
        for component: Calendar.Component,
        value: Int
    ) -> String? {
        let currentDate = Date()

        let calendar = Calendar.current

        if let newDate = calendar.date(
            byAdding: component,
            value: value,
            to: currentDate
        ) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: newDate)
            return formattedDate
        }

        return nil
    }
}
