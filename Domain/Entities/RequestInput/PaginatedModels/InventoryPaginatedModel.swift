//
//  InventoryPaginatedModel.swift
//  Domain
//
//  Created by George Churikov on 13.03.2024.
//

import Foundation

public struct InventoryPaginatedModel {
    public let limit = 15
    public var offset: Int? = nil
    public var noCOGs: Bool? = nil
    public var searchText: String? = nil
    public var tableType: InventoryTableType
}

public enum InventoryTableType {
    case orders
    case buyBotImports
}
