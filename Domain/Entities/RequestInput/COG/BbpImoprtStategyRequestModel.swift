//
//  BbpImoprtStategyRequestModel.swift
//  Domain
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation

public struct BbpImoprtStategyRequestModel: Encodable {
    public let id: Int
    public let applyToUnsoldInventory: Bool
    public let strategy: String
    
    public init(
        id: Int,
        applyToUnsoldInventory: Bool,
        strategy: String
    ) {
        self.id = id
        self.applyToUnsoldInventory = applyToUnsoldInventory
        self.strategy = strategy
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case applyToUnsoldInventory = "apply_to_unsold_inventory"
        case strategy
    }
    
}
