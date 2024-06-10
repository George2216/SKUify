//
//  Currencies.swift
//  SKUify
//
//  Created by George Churikov on 10.06.2024.
//

import Foundation

enum CurrencyType: CaseIterable {
    case eu
    case us
    case gb
    
    init(key: String) {
        switch key {
        case "EUR":
            self = .eu
        case "USD":
            self = .us
        case "GBP":
            self = .gb
        default:
            fatalError()
        }
    }
    
    init(title: String) {
        switch title {
        case "EUR€":
            self = .eu
        case "USD$":
            self = .us
        case "GBP£":
            self = .gb
        default:
            fatalError()
        }
    }
    
    var key: String {
        switch self {
        case .eu:
           return "EUR"
        case .us:
            return "USD"
        case .gb:
            return "GBP"
        }
    }
    
    var title: String {
        switch self {
        case .eu:
           return "EUR€"
        case .us:
            return "USD$"
        case .gb:
            return "GBP£"
        }
    }
    
}
