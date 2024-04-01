//
//  SalesOrdersDTO.swift
//  Domain
//
//  Created by George Churikov on 12.02.2024.
//

import Foundation

public struct SalesOrdersMainDTO: Decodable {
    public let orders: SalesOrdersResultsDTO
}

public struct SalesOrdersResultsDTO: Decodable {
    public let results: [SalesOrdersDTO]
    public let count: Int
}

public struct SalesOrdersDTO: Decodable {
    public let id: Int
    public let imageUrl: String?
    public let title: String
    public let sellerSku: String
    public let asin: String
    public let amazonOrderId: String
    public let marketplace: String
    public let purchaseDate: String
    public let quantityOrdered: Int
    public let originalPrice: OriginalPriceDTO
    public let amzFees: Double?
    public let totalCog: Double // Unit cost for COG
    public let currencySymbol: String
    public let profit: Double
    public let roi: Double?
    public let margin: Double?
    public let orderStatus: String
    public let shippingTo: SalesOriginShippingToDTO?
    public let fulfillment: String
    public let note: String?
    public let vatRate: Int
    // MARK: - Only GOG
    
    public let bundling: Double?
    public let prepFee: Double?
    public let packaging: Double?
    public let handling: Double?
    public let other: Double?
    public let shipping: Double?
//    //
//    public let extraFee: String?
//    public let extraFeePerc: Double?


    
    private enum CodingKeys: String, CodingKey {
        case id
        case imageUrl = "full_image_url"
        case title 
        case sellerSku = "seller_sku"
        case asin = "asin"
        case amazonOrderId = "order__amazon_order_id"
        case marketplace = "marketplace"
        case purchaseDate = "order__purchase_date"
        case quantityOrdered = "quantity_ordered"
        case originalPrice = "original_price"
        case amzFees = "amz_fees"
        case totalCog = "total_cog"
        case currencySymbol = "currency_symbol"
        case profit = "profit"
        case roi = "roi"
        case margin = "margin"
        case orderStatus = "order__order_status"
        case shippingTo = "shipping_to"
        case fulfillment = "order__fulfillment_channel"
        case note = "note"
        case vatRate = "product__vat_rate"
        case bundling = "bundling"
        case prepFee = "prep_centre"
        case packaging = "packaging"
        case handling = "handling"
        case other = "other"
        case shipping = "postage"
//        case extraFee = "extra_fee"
//        case extraFeePerc = "extra_fee_perc"
    }
    
}

public struct SalesOriginShippingToDTO: Decodable {
    public let countryCode: String?
    public let city: String?
    public let region: String?
    
    private enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case city = "city"
        case region = "state_or_region"
    }
    
}
