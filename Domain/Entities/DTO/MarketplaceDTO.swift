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


