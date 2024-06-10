//
//  CurrencyRequestModel.swift
//  Domain
//
//  Created by George Churikov on 10.06.2024.
//

import Foundation

public struct CurrencyRequestModel: Encodable {
    public var userId: Int
    public var currency: String
    
    public init(
        userId: Int,
        currency: String
    ) {
        self.userId = userId
        self.currency = currency
    }
    
}
