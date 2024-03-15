//
//  SalesDTO.swift
//  Domain
//
//  Created by George Churikov on 06.02.2024.
//

import Foundation

public struct SalesRefundsMainDTO: Decodable {
    public let refunds: SalesRefundsResultsDTO
}

public struct SalesRefundsResultsDTO: Decodable {
    public let results: [SalesRefundsDTO]
    public let count: Int
}

public struct SalesRefundsDTO: Decodable {
    public let id: Int
    public let imageUrl: String?
    public let title: String
    public let sellerSku: String
    public let asin: String
    public let amazonOrderId: String
    public let marketplace: String
    public let refundDate: String
    public let quantityOrdered: Int
    public let originalPrice: SalesOriginalPriceDTO
    public let amzFees: Double?
    public let totalCog: Double
    public let currencySymbol: String
    public let refundСost: Double
    public let orderStatus: String
    public let fulfillment: String
    public let note: String?
    public let vatRate: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case imageUrl = "full_image_url"
        case title = "title"
        case sellerSku = "seller_sku"
        case asin = "asin"
        case amazonOrderId = "order__amazon_order_id"
        case marketplace = "marketplace"
        case refundDate = "refund_date"
        case quantityOrdered = "quantity_ordered"
        case originalPrice = "original_price"
        case amzFees = "amz_fees"
        case totalCog = "total_cog"
        case currencySymbol = "currency_symbol"
        case refundСost = "refund_cost"
        case orderStatus = "order__order_status"
        case fulfillment = "order__fulfillment_channel"
        case note = "note"
        case vatRate = "product__vat_rate"
    }
    
}

