//
//  InventoryOrdersResultsDTO.swift
//  Domain
//
//  Created by George Churikov on 15.03.2024.
//

import Foundation

public struct InventoryOrdersResultsDTO: Decodable {
    public let results: [InventoryOrderDTO]
    public let count: Int
}

public struct InventoryOrderDTO: Decodable {
    public let id: Int
    public let imageUrl: String?
    public let title: String
    public let sellerSku: String
    public let asin: String
    public let marketplace: String
    public let originalPrice: OriginalPriceDTO
    public let currentStock: Int
    public let amzFees: Double?
    public let cog: Double
    public let profit: Double?
    public let roi: Double?
    public let margin: Double?
    public let fulfillment: String
    public let note: String?
    public let vatRate: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageUrl = "full_image_url"
        case title = "item_name"
        case sellerSku = "seller_sku"
        case asin = "asin1"
        case marketplace = "marketplace"
        case originalPrice = "original_price"
        case currentStock = "current_stock"
        case amzFees = "amazon_fees"
        case cog = "cog"
        case profit = "profit"
        case roi = "roi"
        case margin = "margin"
        case fulfillment = "fulfillment"
        case note = "note"
        case vatRate = "vat_rate"
    }
    
}

