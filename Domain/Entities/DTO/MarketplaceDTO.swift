//
//  MarketplaceDTO.swift
//  Domain
//
//  Created by George Churikov on 03.01.2024.
//

import Foundation

public struct MarketplaceDTO: Decodable {
    public let marketplaceId: String
    public let endpoint: String
    public let websiteUrl: String
    public let countryCode: String
    public let country: String
    public let order: Int
    public let location: String
    public let participate: Bool
    
    public init(
        marketplaceId: String,
        endpoint: String,
        websiteUrl: String,
        countryCode: String,
        country: String,
        order: Int,
        location: String,
        participate: Bool
    ) {
        self.marketplaceId = marketplaceId
        self.endpoint = endpoint
        self.websiteUrl = websiteUrl
        self.countryCode = countryCode
        self.country = country
        self.order = order
        self.location = location
        self.participate = participate
    }
    
    private enum CodingKeys: String, CodingKey {
        case marketplaceId = "marketplace_id"
        case endpoint = "endpoint"
        case websiteUrl = "website_url"
        case countryCode = "country_code"
        case country = "country"
        case order = "order"
        case location = "location"
        case participate = "participate"
    }
    
}


extension MarketplaceDTO: Equatable {
    public static func == (
        lhs: MarketplaceDTO,
        rhs: MarketplaceDTO
    ) -> Bool {
        lhs.marketplaceId == rhs.marketplaceId &&
        lhs.endpoint == rhs.endpoint &&
        lhs.websiteUrl == rhs.websiteUrl &&
        lhs.countryCode == rhs.countryCode &&
        lhs.country == rhs.country &&
        lhs.order == rhs.order &&
        lhs.location == rhs.location &&
        lhs.participate == rhs.participate
    }
    
}
