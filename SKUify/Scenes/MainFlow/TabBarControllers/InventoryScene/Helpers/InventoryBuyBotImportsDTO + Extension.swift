//
//  InventoryBuyBotImportsDTO + Extension.swift
//  SKUify
//
//  Created by George Churikov on 30.04.2024.
//

import Foundation
import Domain

extension InventoryBuyBotImportsDTO {
    func toCOGSettingsInputModel() -> COGSettingsInputModel {
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
              quantity: quantity,
              purchasedFrom: purchasedFrom,
              purchaseDate: purchasedDate?.toDate() ?? Date(),
              bundled: bundled,
              fulfilment: fulfillment, 
              bbpImportStrategy: BBPImportStrategy(rawValue: bbpImportStrategy.strategy),
              bbpItemData: toBbpCogSettingsItem(),
              skuifyItemData: .init(), // instatiate on COG screen
              editItemData: toEditCogSettingsItem(), 
              applyToUnsoldInventory: bbpImportStrategy.applyToUnsoldInventory
          )
      }
  
    
    private func toBbpCogSettingsItem() -> COGSettingsItem {
        .init(
            bundling: rawBbp.fees.bundling,
            extraFee: rawBbp.fees.extraFee,
            extraFeePerc: nil,
            handling: nil,
            other: nil,
            packaging: nil,
            postage: nil,
            prepCentre: rawBbp.fees.prepFee,
            vatFreePostage: nil
        )
    }
    
    private func toEditCogSettingsItem() -> COGSettingsItem {
        .init(
            bundling: bundling,
            extraFee: extraFee,
            extraFeePerc: extraFeePerc,
            handling: handling,
            other: other,
            packaging: packaging,
            postage: postage,
            prepCentre: prepFee,
            vatFreePostage: nil
        )
    }
    
}
