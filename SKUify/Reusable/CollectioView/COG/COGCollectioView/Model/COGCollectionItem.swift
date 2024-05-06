//
//  COGCollectionItem.swift
//  SKUify
//
//  Created by George Churikov on 30.03.2024.
//

import Foundation

enum COGCollectionItem {
    case main(_ input: COGMainCell.Input)
    case purchaseDetail(_ input: COGPurchaseDetailCell.Input)
    case costOfGoods(_ input: COGCostOfGoodsCell.Input)
    case costSummary(_ input: COGCostSummaryCell.Input)
    case importStrategy(_ input: COGImportStrategyCell.Input)
    case applyToInventory(_ input: COGApplyToInventoryCell.Input)
}

