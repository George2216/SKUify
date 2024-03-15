//
//  SalesPaginatedModel.swift
//  Domain
//
//  Created by George Churikov on 05.02.2024.
//

import Foundation
 
public struct SalesPaginatedModel {
    public let limit = 15
    public var offset: Int? = nil
    public var noCOGs: Bool? = nil
    public var searchText: String? = nil
    public var period: SalesPeriodType
    public var tableType: SalesTableType
    public var marketplaceType: SalesMarketplaceType
    
    public static func base() -> SalesPaginatedModel {
        .init(
            period: .all,
            tableType: .orders,
            marketplaceType: .all
        )
    }
}

public enum SalesPeriodType {
    case all
    case byRange(
        _ startDate: String,
        _ endDate: String
    )
}

public enum SalesTableType {
    case orders
    case refunds
}

public enum SalesMarketplaceType {
    case all
    case marketplace(_ marketplaceCode: String)
}

