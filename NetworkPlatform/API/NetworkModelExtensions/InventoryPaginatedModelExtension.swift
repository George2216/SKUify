//
//  InventoryPaginatedModelExtension.swift
//  NetworkPlatform
//
//  Created by George Churikov on 15.03.2024.
//

import Foundation
import Domain

extension InventoryPaginatedModel {
    func toDictionary() -> [String: String] {
       return [
            "limit": "\(limit)",
            "offset": offset.toStringOrEmpty,
            "no_inventory_cost": noCOGs?.trueOrEmptyString ?? "",
            "stock_or_inactive": stockOrInactive?.trueOrEmptyString ?? "",
            "only_warning": onlyWarning?.trueOrEmptyString ?? "",
            "q": searchText.toStringOrEmpty
        ]
    }
    
}

// MARK: - Make path buy table type

extension InventoryPaginatedModel {
    func path() -> String {
        switch tableType {
        case .orders:
            return "inventory"
        case .buyBotImports:
            return "product/bbp"
        }
    }
    
}
