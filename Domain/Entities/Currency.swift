//
//  Currency.swift
//  Domain
//
//  Created by George Churikov on 10.06.2024.
//

import Foundation

public struct Currency {
    public let currency: String
    
    public init(currency: String) {
        self.currency = currency
    }
    
}

extension Currency: Equatable {
    public static func == (
        lhs: Currency,
        rhs: Currency
    ) -> Bool {
        return lhs.currency == rhs.currency
    }
    
}
