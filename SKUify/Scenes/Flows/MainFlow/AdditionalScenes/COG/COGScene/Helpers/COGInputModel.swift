//
//  COGInputModel.swift
//  SKUify
//
//  Created by George Churikov on 01.04.2024.
//

import Foundation
import Domain

struct COGInputModel {
    var isAsinUpdate: Bool?
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
    // Cost of Goods Information
    var bundling: Double?
    var prepFee: Double?
    var packaging: Double?
    var handling: Double?
    var other: Double?
    var shipping: Double?
    var inboundShipping: Double?
    var extraFee: Double?
    var extraFeePerc: Double?
    var inboundShippingUnits: Double?
    var breakEvenPoint: Double?
    
    var cogType: COGType

    func clearCostOfGoods() -> Self {
        var copy = self
        copy.bundling = nil
        copy.prepFee = nil
        copy.packaging = nil
        copy.handling = nil
        copy.other = nil
        copy.shipping = nil
        copy.inboundShipping = nil
        copy.extraFee = nil
        copy.extraFeePerc = nil
        copy.inboundShippingUnits = nil
        return copy
    }
    
     func calculateTotalCost() -> Double {
         var extraFeeValue: Double = 0.00
         
         extraFeeValue += extraFee.valueOrZero()
         extraFeeValue += extraFeePerc.valueOrZero() * unitCost.valueOrZero() / 100
         
         return unitCost.valueOrZero() +
         bundling.valueOrZero() +
         prepFee.valueOrZero() +
         packaging.valueOrZero() +
         handling.valueOrZero() +
         other.valueOrZero() +
         shipping.valueOrZero() +
         inboundShipping.valueOrZero() +
         extraFeeValue +
         inboundShippingUnits.valueOrZero()
     }
    
    // Hepler method
    
    private func calculateInventoryCost() -> Double? {
        guard let unitCost else { return nil }
        guard let extraFeePerc else { return unitCost }
        return (extraFeePerc * unitCost) / 100 + unitCost
    }
    
}

// MARK: - To request models

extension COGInputModel {
    
    func toSalesRequestModel() -> Domain.COGSalesRequestModel {
        .init(
            id: id,
            asinUpdate: isAsinUpdate,
            bundling: bundling,
            prepCentre: prepFee,
            packaging: packaging,
            price: price,
            quantity: quantity,
            inventoryCost: unitCost,
            handling: handling,
            other: other,
            postage: shipping,
            purchasedFrom: purchasedFrom,
            purchasedDate: purchaseDate.yyyyMMddTHHmmString(),
            bundled: bundled,
            extraFee: extraFee,
            extraFeePerc: extraFeePerc,
            inboundShipping: inboundShipping
        )
    }
    
    func toInventoryRequestModel() -> Domain.COGInventoryRequestModel {
        .init(
            id: id,
            bundling: bundling,
            prepCentre: prepFee,
            packaging: packaging,
            price: price,
            quantity: quantity,
            inventoryCost: unitCost,
            handling: handling,
            other: other,
            postage: shipping,
            purchasedFrom: purchasedFrom,
            purchasedDate: purchaseDate.yyyyMMddTHHmmString(),
            bundled: bundled,
            extraFee: extraFee,
            extraFeePerc: extraFeePerc,
            inboundShipping: inboundShipping
        )
    }
    
    func toBreakEvenRequestModel() -> Domain.COGBreakEvenRequestModel {
        .init(
            id: id,
            inventoryCost: calculateInventoryCost().valueOrZero(),
            cogs: [
                .bundling: bundling.valueOrZero(),
                .prepCentre: prepFee.valueOrZero(),
                .handling: handling.valueOrZero(),
                .other: other.valueOrZero(),
                .extraFee: extraFee.valueOrZero(),
                .postage: shipping.valueOrZero(),
                .packaging: packaging.valueOrZero(),
                .inboundShipping: inboundShipping.valueOrZero()
            ]
        )
    }
    
    func toReplenishRequestModel() -> Domain.ReplenishCOGRequestModel {
        .init(
            id: id,
            asin: asin,
            bundling: bundling,
            prepCentre: prepFee,
            packaging: packaging,
            price: price,
            quantity: quantity,
            inventoryCost: unitCost,
            handling: handling,
            other: other,
            postage: shipping,
            purchasedFrom: purchasedFrom,
            purchasedDate: purchaseDate.yyyyMMddTHHmmString(),
            bundled: bundled,
            extraFee: extraFee,
            extraFeePerc: extraFeePerc,
            inboundShipping: inboundShipping
        )
    }
    
}

enum COGType {
    case sales
    case inventory
    case replenish
    case newReplenish
    
}
