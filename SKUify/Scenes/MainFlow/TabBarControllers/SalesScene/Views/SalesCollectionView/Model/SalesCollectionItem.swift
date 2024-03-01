//
//  SalesCollectionItem.swift
//  SKUify
//
//  Created by George Churikov on 09.02.2024.
//

import Foundation

enum SalesCollectionItem {
    case orders(_ input: SalesOrdersCell.Input)
    case refunds(_ input: SalesRefundsCell.Input)
}
