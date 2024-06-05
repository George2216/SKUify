//
//  Subscription.swift
//  Domain
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation

public struct SubscriptionDTO: Decodable {
    public let iconUrl: String
    public let title: String
    public let subtitle: String
    public let price: Double
    public let list: [String]
    public let currency: Currency
    public let intervalUnit: String
    
    public struct Currency: Decodable {
        public let symbol: String
    }
    
    enum CodingKeys: String, CodingKey {
        case iconUrl = "icon_url"
        case title
        case subtitle
        case price
        case list
        case currency
        case intervalUnit = "interval_unit"
    }
    
}
