//
//  SalesRefundsDTO + Extension.swift
//  SKUify
//
//  Created by George Churikov on 17.04.2024.
//

import Foundation
import Domain

extension SalesRefundsDTO {
    func toCOGInputModel() -> COGInputModel {
        .init(
            id: id,
            title: title,
            asin: asin,
            sku: sellerSku,
            price: originalPrice.price,
            dataAdded: dateAdded.toDate(),
            imageUrl: imageUrl,
            unitCost: unitCost,
            currencySymbol: originalPrice.currency,
            quantity: quantityOrdered,
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
            cogType: .sales
        )
    }
    
}
