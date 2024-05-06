//
//  ReplenishCOGRequestModel.swift
//  Domain
//
//  Created by George Churikov on 19.04.2024.
//

import Foundation

public struct ReplenishCOGRequestModel: Encodable {
    public var id: Int
    public var asin: String
    public let bundling: Double?
    public let prepCentre: Double?
    public let packaging: Double?
    public let price: Double?
    public let quantity: Int?
    public let inventoryCost: Double?
    public let handling: Double?
    public let other: Double?
    public let postage: Double?
    public let purchasedFrom: String?
    public let purchasedDate: String
    public let bundled: Bool
    public let extraFee: Double?
    public let extraFeePerc: Double?
    public let inboundShipping: Double?
    
    private enum CodingKeys: String, CodingKey {
        case id = "parent_id"
        case asin = "asin1"
        case bundling
        case prepCentre = "prep_centre"
        case packaging
        case price
        case quantity
        case inventoryCost = "inventory_cost"
        case handling
        case other
        case postage
        case purchasedFrom = "purchased_from"
        case purchasedDate = "purchased_date"
        case bundled
        case extraFee = "extra_fee"
        case extraFeePerc = "extra_fee_perc"
        case inboundShipping = "inbound_shipping"
    }
    
    public init(
        id: Int,
        asin: String,
        bundling: Double?,
        prepCentre: Double?,
        packaging: Double?,
        price: Double?,
        quantity: Int?,
        inventoryCost: Double?,
        handling: Double?,
        other: Double?,
        postage: Double?,
        purchasedFrom: String?,
        purchasedDate: String,
        bundled: Bool,
        extraFee: Double?,
        extraFeePerc: Double?,
        inboundShipping: Double?
    ) {
        self.id = id
        self.asin = asin
        self.bundling = bundling
        self.prepCentre = prepCentre
        self.packaging = packaging
        self.price = price
        self.quantity = quantity
        self.inventoryCost = inventoryCost
        self.handling = handling
        self.other = other
        self.postage = postage
        self.purchasedFrom = purchasedFrom
        self.purchasedDate = purchasedDate
        self.bundled = bundled
        self.extraFee = extraFee
        self.extraFeePerc = extraFeePerc
        self.inboundShipping = inboundShipping
    }
    
}
