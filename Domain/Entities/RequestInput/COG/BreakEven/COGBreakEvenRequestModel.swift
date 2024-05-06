//
//  COGBreakEvenRequestModel.swift
//  Domain
//
//  Created by George Churikov on 18.04.2024.
//

import Foundation

public struct COGBreakEvenRequestModel: Encodable {
    @Ignore public var id: Int
    public let inventoryCost: Double
    public let cogs: [COGBreakEvenRequestItem: Double]
    
    private enum CodingKeys: String, CodingKey {
        case inventoryCost = "inventory_cost"
        case cogs
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(
            inventoryCost,
            forKey: .inventoryCost
        )
        
        var cogsContainer = container.nestedUnkeyedContainer(forKey: .cogs)
        for (key, value) in cogs {
            var nestedContainer = cogsContainer.nestedContainer(keyedBy: COGBreakEvenRequestItem.self)
            try nestedContainer.encode(
                value,
                forKey: key
            )
        }
    }
    
    public init(
        id: Int,
        inventoryCost: Double,
        cogs: [COGBreakEvenRequestItem: Double]
    ) {
        self.id = id
        self.inventoryCost = inventoryCost
        self.cogs = cogs
    }
    
}

public enum COGBreakEvenRequestItem: String, CodingKey {
    case bundling
    case prepCentre = "prep_centre"
    case handling
    case other
    case extraFee = "extra_fee"
    case postage
    case packaging
    case inboundShipping = "inbound_shipping"
    
}
