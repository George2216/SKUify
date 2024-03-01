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
    public let image_url: String?
    public let title: String
    public let seller_sku: String
    public let asin: String
    public let order__amazon_order_id: String
    public let marketplace: String
    public let order__purchase_date: String
    public let quantity_ordered: Int
    public let original_price: SalesOriginalPriceDTO
    public let amz_fees: Double
    public let cog: Double
    public let profit: Double
    public let roi: Double?
    public let margin: Double?
    public let order__order_status: String
    public let shipping_to: SalesOriginShippingToDTO?
    public let order__fulfillment_channel: String
    public let note: String?
    public let product__vat_rate: Int
}

public struct SalesOriginShippingToDTO: Decodable {
    let country_code: String?
    let city: String?
    let state_or_region: String?
}
