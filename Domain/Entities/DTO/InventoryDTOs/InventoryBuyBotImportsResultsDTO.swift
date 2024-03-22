//
//  InventoryBuyBotImportsResultsDTO.swift
//  Domain
//
//  Created by George Churikov on 20.03.2024.
//

import Foundation

public struct InventoryBuyBotImportsResultsDTO: Decodable {
    public let results: [InventoryBuyBotImportsDTO]
    public let count: Int
}

public struct InventoryBuyBotImportsDTO: Decodable {
    public let id: Int
    public let imageUrl: String?
    public let title: String
    public let sellerSku: String
    public let asin: String
    public let marketplace: String
    public let price: Double
    public let originalPrice: OriginalPriceDTO
    public let stock: Int
    public let amzFees: Double?
    public let cog: Double
    public let profit: Double?
    public let roi: Double?
    public let margin: Double?
    public let fulfillment: String
    public let note: String?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageUrl = "full_image_url"
        case title = "item_name"
        case sellerSku = "seller_sku"
        case asin = "asin1"
        case marketplace = "marketplace"
        case price = "price"
        case originalPrice = "original_price"
        case stock = "current_stock"
        case amzFees = "amazon_fees"
        case cog = "cog"
        case profit = "profit"
        case roi = "roi"
        case margin = "margin"
        case fulfillment = "fulfillment"
        case note = "note"
    }

}


