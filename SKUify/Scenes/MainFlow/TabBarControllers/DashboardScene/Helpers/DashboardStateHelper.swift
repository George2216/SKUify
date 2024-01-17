//
//  DashboardStateHelper.swift
//  SKUify
//
//  Created by George Churikov on 03.01.2024.
//

import Foundation

enum DashboardDataState {
    case today
    case yesterday
    case days7
    case days30
    case days90
    case days365
    case all
    case custom(
        startDate: Date,
        endDate: Date?
    )
}

// MARK: Properties

extension DashboardDataState {
    var title: String {
        switch self {
        case .today:
            return "Today"
        case .yesterday:
            return "Yesterday"
        case .all:
            return "All"
        case .custom:
            return "Custom"
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
    
    var startDate: String {
        switch self {
        case .today:
            return formattedDate(
                for: .day,
                value: 0
            ) ?? ""
        case .yesterday:
            return formattedDate(
                for: .day,
                value: -1
            ) ?? ""
        case .days7:
            return formattedDate(
                for: .weekOfYear,
                value: -1
            ) ?? ""
        case .days30:
            return formattedDate(
                for: .day,
                value: -29
            ) ?? ""
        case .days90:
            return formattedDate(
                for: .day,
                value: -90
            ) ?? ""
        case .days365:
            return formattedDate(
                for: .year,
                value: -1
            ) ?? ""
        case .all:
            return ""
        case .custom(let startDate,_):
            return startDate.yyyyMMddString()
        }
    }
    
    var endDate: String {
        switch self {
        case .custom(_, let endDate):
            guard let endDate else { return "" }
            return endDate.yyyyMMddString()
        default:
            return ""
        }
    }
}

// MARK: You need to implement allCases as it uses an associative value.

extension DashboardDataState: CaseIterable {
    static var allCases: [DashboardDataState] = [
        .today,
            .yesterday,
            .days7,
            .days30,
            .days90,
            .days365,
            .all,
            .custom(
                startDate: Date(),
                endDate: nil
            )
    ]
    
}

// MARK: Date formater

extension DashboardDataState {
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
            return newDate.yyyyMMddString()
        }

        return nil
    }
    
    
}

