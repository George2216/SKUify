//
//  AmazonSettingsDTO.swift
//  Domain
//
//  Created by George Churikov on 01.03.2024.
//

import Foundation

public struct AmazonSettingsDTO: Decodable {
    public let id: Int
    public let marketplaces: [MarketplaceDTO]
}
