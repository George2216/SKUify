//
//  PeriodType.swift
//  SKUify
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation

enum PeriodType: String, CaseIterable {
    case once
    case daily
    case weekly
    case bimonthly
    case monthly
    case quarterly
    case biannual
    case yearly
    
    init(rawValue: String) {
        if let index = Self.allCases
            .map({ $0.key })
            .firstIndex(of: rawValue) {
            self = Self.allCases[index]
        } else {
            fatalError("Period type failed")
        }
    }
    
    init(index: Int) {
        self = Self.allCases[index]
    }
    
    var key: String {
        switch self {
        case .once:
            return "ONCE"
        case .daily:
            return "DAILY"
        case .weekly:
            return "WEEKLY"
        case .bimonthly:
            return "BIMONTHLY"
        case .monthly:
            return "MONTHLY"
        case .quarterly:
            return "QUARTERLY"
        case .biannual:
            return "BIANNUAL"
        case .yearly:
            return "YEARLY"
        }
    }
   
    var title: String {
        switch self {
        case .once:
            return "Once"
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .bimonthly:
            return "Bimonthly"
        case .monthly:
            return "Monthly"
        case .quarterly:
            return "Quarterly"
        case .biannual:
            return "Biannual"
        case .yearly:
            return "Yearly"
        }
    }
    
    var index: Int {
        Self.allCases
            .firstIndex(of: self)!
    }
    
}
