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
    public let price: Double?
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
    
    // MARK: - Only GOG
    
    public let quantity: Int
    public let dateAdded: String
    public let unitCost: Double?
    public let purchasedFrom: String?
    public let purchasedDate: String?
    public let bundled: Bool
    public let bundling: Double?
    public let prepFee: Double?
    public let packaging: Double?
    public let handling: Double?
    public let other: Double?
    public let shipping: Double?
    public let vatFreeShipping: Double?
    public let inboundShippingCost: Double?
    public let extraFee: Double?
    public let extraFeePerc: Double?
    public let inboundShippingUnits: Double?
    public let breakEvenPoint: Double?
    
    // MARK: - Replenishes
    
    public let restocks: [[InventoryOrderDTO]]
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageUrl = "full_image_url"
        case title = "item_name"
        case sellerSku = "seller_sku"
        case asin = "asin1"
        case marketplace = "marketplace"
        case price
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
        
        case quantity
        case dateAdded = "date_added"
        case unitCost = "inventory_cost"
        case purchasedFrom = "purchased_from"
        case purchasedDate = "purchased_date"
        case bundled
        case bundling
        case prepFee = "prep_centre"
        case packaging = "packaging"
        case handling = "handling"
        case other = "other"
        case shipping = "postage"
        case vatFreeShipping = "vat_free_postage"
        case inboundShippingCost = "inbound_shipping"
        case extraFee = "extra_fee"
        case extraFeePerc = "extra_fee_perc"
        case inboundShippingUnits = "inbound_shipping_units"
        case breakEvenPoint = "break_even_point"
        
        case restocks
    }
    
}


public struct InventoryReplenishDTO: Decodable {
    public let quantity: Int
    public let dateAdded: String
    public let unitCost: Double?
    public let purchasedFrom: String?
    public let purchasedDate: String?
    public let bundled: Bool?
    public let bundling: Double?
    public let prepFee: Double?
    public let packaging: Double?
    public let handling: Double?
    public let other: Double?
    public let shipping: Double?
    public let vatFreeShipping: Double?
    public let inboundShippingCost: Double?
    public let extraFee: Double?
    public let extraFeePerc: Double?
    public let inboundShippingUnits: Double?
    public let breakEvenPoint: Double?
    
    private enum CodingKeys: String, CodingKey {
        case quantity
        case dateAdded = "date_added"
        case unitCost = "inventory_cost"
        case purchasedFrom = "purchased_from"
        case purchasedDate = "purchased_date"
        case bundled
        case bundling
        case prepFee = "prep_centre"
        case packaging = "packaging"
        case handling = "handling"
        case other = "other"
        case shipping = "postage"
        case vatFreeShipping = "vat_free_postage"
        case inboundShippingCost = "inbound_shipping"
        case extraFee = "extra_fee"
        case extraFeePerc = "extra_fee_perc"
        case inboundShippingUnits = "inbound_shipping_units"
        case breakEvenPoint = "break_even_point"
        
    }
}
