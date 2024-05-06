//
//  COGBreakEven.swift
//  Domain
//
//  Created by George Churikov on 18.04.2024.
//

import Foundation

struct COGBreakEven: Encodable {
    
    let inventoryCost: Double
    var cogs: [COGBreakEvenItem: Double]
    
    private enum CodingKeys: String, CodingKey {
        case inventoryCost = "inventory_cost"
        case cogs
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(inventoryCost, forKey: .inventoryCost)
        
        var cogsContainer = container.nestedUnkeyedContainer(forKey: .cogs)
        for (key, value) in cogs {
            var nestedContainer = cogsContainer.nestedContainer(keyedBy: COGBreakEvenItem.self)
            try nestedContainer.encode(value, forKey: key)
        }
    }
}

enum COGBreakEvenItem: String, CodingKey {
    case prepCentre = "prep_centre"
    case handling = "handling"
    case other = "other"
    case extraFee = "extra_fee"
    case postage = "postage"
    case packaging = "packaging"
}
