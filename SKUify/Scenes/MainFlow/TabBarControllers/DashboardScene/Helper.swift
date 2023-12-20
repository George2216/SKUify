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
    
}
