//
//  SalesPaginatedModelExtension.swift
//  NetworkPlatform
//
//  Created by George Churikov on 09.02.2024.
//

import Foundation
import Domain

extension SalesPaginatedModel {
    func toDictionary() -> [String: String] {
        var baseDict = [
            "limit": limit.description,
            "offset": offset.toStringOrEmpty,
            "no_inventory_cost": noCOGs?.trueOrEmptyString ?? "",
            "q": searchText.toStringOrEmpty
        ]
        
        baseDict.merge(
            makePeriod(),
            uniquingKeysWith: { first , _ in
                return first
            }
        )
        baseDict.merge(
            makeTable(),
            uniquingKeysWith: { first , _ in
                return first
            }
        )
        baseDict.merge(
            makeMarketplace(),
            uniquingKeysWith: { first , _ in
                return first
            }
        )
        
        return baseDict
    }
    
    private func makePeriod() -> [String: String] {
        switch period {
        case .all:
            return [:]
        case .byRange(let startDate, let endDate):
            return [
                "start_date": startDate,
                "end_date": endDate
            ]
        }
    }
    
    private func makeTable() -> [String: String] {
        let key = "table"

        switch tableType {
        case .refunds:
            return [key: "refunds"]
        case .orders:
            return [key: "orders"]
        }
    }
    
    private func makeMarketplace() -> [String: String] {
        let key = "marketplace"
        switch marketplaceType {
        case .all:
          return  [key: "all_marketplaces"]
        case .marketplace(let code):
           return [key: code]
        }
    }
    
}
