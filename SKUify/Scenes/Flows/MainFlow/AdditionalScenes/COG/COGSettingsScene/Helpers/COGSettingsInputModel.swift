//
//  COGSettingsInputModel.swift
//  SKUify
//
//  Created by George Churikov on 30.04.2024.
//

import Foundation
import Domain

struct COGSettingsInputModel {
    let id: Int
    let title: String
    let asin: String
    let sku: String
    let price: Double
    let dataAdded: Date
    let imageUrl: String?
    // Main Goods information
    var unitCost: Double?
    let currencySymbol: String
    var quantity: Int?
    var purchasedFrom: String?
    var purchaseDate: Date
    var bundled: Bool
    var fulfilment: String
    var bbpImportStrategy: BBPImportStrategy
    let bbpItemData: COGSettingsItem
    var skuifyItemData: COGSettingsItem
    let editItemData: COGSettingsItem
    var applyToUnsoldInventory: Bool
    
}

// MARK: - To request model

extension COGSettingsInputModel {
    func toImportStrategyRequestModel() -> Domain.BbpImoprtStategyRequestModel {
        .init(
            id: id,
            applyToUnsoldInventory: applyToUnsoldInventory,
            strategy: bbpImportStrategy.key
        )
    }
    
    func toCOGSettingsRequestModel() -> Domain.COGSettingsRequestModel {
        .init(
            id: id,
            unitCost: unitCost.valueOrZero(),
            quantity: quantity ?? 0,
            purchasedFrom: purchasedFrom,
            purchasedDate: purchaseDate.yyyyMMddTHHmmString(),
            bundled: bundled
        )
    }
    
}


struct COGSettingsItem {
    let bundling: Double?
    let extraFee: Double?
    let extraFeePerc: Double?
    let handling: Double?
    let other: Double?
    let packaging: Double?
    let postage: Double?
    let prepCentre: Double?
    let vatFreePostage: Double?
    
    init(
        bundling: Double? = nil,
        extraFee: Double? = nil,
        extraFeePerc: Double? = nil,
        handling: Double? = nil,
        other: Double? = nil,
        packaging: Double? = nil,
        postage: Double? = nil,
        prepCentre: Double? = nil,
        vatFreePostage: Double? = nil
    ) {
        self.bundling = bundling
        self.extraFee = extraFee
        self.extraFeePerc = extraFeePerc
        self.handling = handling
        self.other = other
        self.packaging = packaging
        self.postage = postage
        self.prepCentre = prepCentre
        self.vatFreePostage = vatFreePostage
    }

}

extension COGSettingsItem {
    
    func calculateTotalCosts(_ unitCost: Double?) -> Double {
        unitCost.valueOrZero() + 
        bundling.valueOrZero() +
        extraFee.valueOrZero() +
        extraFeePerc.valueOrZero() * unitCost.valueOrZero() / 100 +
        handling.valueOrZero() +
        other.valueOrZero() +
        packaging.valueOrZero() +
        postage.valueOrZero() +
        prepCentre.valueOrZero() +
        vatFreePostage.valueOrZero()
        
    }
    
    func calculateGrossProfit(
        _ unitCost: Double?,
        price: Double?
    ) -> Double {
        price.valueOrZero() - calculateTotalCosts(unitCost)
    }
    
}
