//
//  SalesDTO.swift
//  Domain
//
//  Created by George Churikov on 06.02.2024.
//

import Foundation

public struct SalesRefundsMainDTO: Decodable {
    public let refunds: SalesRefunsResultsDTO
}

public struct SalesRefunsResultsDTO: Decodable {
    public let results: [SalesRefundsDTO]
    public let count: Int
}

public struct SalesRefundsDTO: Decodable {
    public let id: Int
    public let image_url: String?
    public let title: String
    public let seller_sku: String
    public let asin: String
    public let order__amazon_order_id: String
    public let marketplace: String
    public let refund_date: String
    public let quantity_ordered: Int
    public let original_price: SalesRefundsOriginalPriceDTO
    public let amz_fees: Double
    public let cog: Double
    public let profit: Double
    public let order__order_status: String
    public let order__fulfillment_channel: String
    public let note: String?
    
    }

public struct SalesRefundsOriginalPriceDTO: Decodable {
    public let price: Double
    public let currency: String
}
