//
//  CalculationMethod.swift
//  SKUify
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation

enum CalculationMethod: String, CaseIterable {
    case accrual
    case cashAccounting
    case balansed

    init(rawValue: String) {
        if let index = Self.allCases
            .map({ $0.key })
            .firstIndex(of: rawValue) {
            self = Self.allCases[index]
        } else {
            fatalError("CalculationMethod failed")
        }
    }
    
    init(index: Int) {
        self = Self.allCases[index]
    }
    
    var key: String {
        switch self {
        case .accrual:
            return "ACCRUAL"
        case .cashAccounting:
            return "CASH_ACCOUNTING"
        case .balansed:
            return "BALANCED"
        }
    }
    
    var title: String {
        switch self {
        case .accrual:
            return "Accrual"
        case .cashAccounting:
            return "Cash Accounting"
        case .balansed:
            return "Balanced"
        }
    }
    
    var index: Int {
        Self.allCases
            .firstIndex(of: self)!
    }
    
}
