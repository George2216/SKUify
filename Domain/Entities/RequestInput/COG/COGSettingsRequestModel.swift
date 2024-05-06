//
//  COGSettingsRequestModel.swift
//  Domain
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation

public struct COGSettingsRequestModel: Encodable {
    public let id: Int
    public let unitCost: Double
    public let quantity: Int
    public let purchasedFrom: String?
    public let purchasedDate: String?
    public let bundled: Bool
    
    public init(
        id: Int,
        unitCost: Double,
        quantity: Int,
        purchasedFrom: String?,
        purchasedDate: String?,
        bundled: Bool
    ) {
        self.id = id
        self.unitCost = unitCost
        self.quantity = quantity
        self.purchasedFrom = purchasedFrom
        self.purchasedDate = purchasedDate
        self.bundled = bundled
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case unitCost = "inventory_cost"
        case quantity
        case purchasedFrom = "purchased_from"
        case purchasedDate = "purchased_date"
        case bundled
    }
    
}
