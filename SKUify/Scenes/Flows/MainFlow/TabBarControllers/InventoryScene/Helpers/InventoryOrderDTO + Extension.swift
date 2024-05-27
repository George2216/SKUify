//
//  InventoryOrderDTO + Extension.swift
//  SKUify
//
//  Created by George Churikov on 18.04.2024.
//

import Foundation
import Domain

extension InventoryOrderDTO {
    func toCOGInputModel(_ type: COGType) -> COGInputModel {
        let quantity = type == .newReplenish ? nil : quantity
       return .init(
            id: id,
            title: title,
            asin: asin,
            sku: sellerSku,
            price: originalPrice.price,
            dataAdded: dateAdded.toDate() ?? Date(),
            imageUrl: imageUrl,
            unitCost: unitCost,
            currencySymbol: originalPrice.currency,
            quantity: quantity,
            purchasedFrom: purchasedFrom,
            purchaseDate: purchasedDate?.toDate() ?? Date(),
            bundled: bundled,
            bundling: bundling,
            prepFee: prepFee,
            packaging: packaging,
            handling: handling,
            other: other,
            shipping: shipping,
            inboundShipping: inboundShippingCost,
            extraFee: extraFee,
            extraFeePerc: extraFeePerc,
            inboundShippingUnits: inboundShippingUnits,
            breakEvenPoint: breakEvenPoint,
            cogType: type
        )
    }
    
}
