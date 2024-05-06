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
    public let cog: Double?
    public let profit: Double?
    public let roi: Double?
    public let margin: Double?
    public let fulfillment: String
    public let note: String?
    
    // MARK: - Only COG settings
    
    public let dateAdded: String
    public let quantity: Int
    public let purchasedFrom: String?
    public let purchasedDate: String?
    public let unitCost: Double?
    public let bundled: Bool
    

    public let bbpImportStrategy: InventoryBBPStrategyDTO
    
    // MARK: - Edit Item
    
    public let bundling: Double?
    public let extraFee: Double?
    public let extraFeePerc: Double?
    public let handling: Double?
    public let other: Double?
    public let packaging: Double?
    public let postage: Double?
    public let prepFee: Double?
    
    // MARK: - BBP Item

    public let rawBbp: InventoryRawBBPDTO
    
    private enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "full_image_url"
        case title = "item_name"
        case sellerSku = "seller_sku"
        case asin = "asin1"
        case marketplace
        case price
        case originalPrice = "original_price"
        case stock = "current_stock"
        case amzFees = "amazon_fees"
        case cog
        case profit
        case roi
        case margin
        case fulfillment
        case note
        
        // MARK: - Only COG settings
        
        case dateAdded = "date_added"
        case quantity
        case purchasedFrom = "purchased_from"
        case purchasedDate = "purchased_date"
        case unitCost = "inventory_cost"
        case bundled
        
        case bbpImportStrategy = "bbp_import_strategy"
        
        case bundling
        case extraFee = "extra_fee"
        case extraFeePerc = "extra_fee_perc"
        case handling
        case other
        case packaging
        case postage
        case prepFee = "prep_centre"
        case rawBbp = "raw_bbp"
    }

}

public struct InventoryBBPStrategyDTO: Decodable {
    public let strategy: String
    public let applyToUnsoldInventory: Bool
    
    private enum CodingKeys: String, CodingKey {
        case strategy = "strategy"
        case applyToUnsoldInventory = "apply_to_unsold_inventory"
    }
    
}

public struct InventoryRawBBPDTO: Decodable {
    public let fees: InventoryRawBBPFeesDTO
    
}

public struct InventoryRawBBPFeesDTO: Decodable {
    public let bundling: Double?
    public let extraFee: Double?
    public let prepFee: Double?
    
    private enum CodingKeys: String, CodingKey {
        case bundling = "bundlePrepFee"
        case extraFee = "extraFees"
        case prepFee = "standardPrepFee"
    }
    
}
