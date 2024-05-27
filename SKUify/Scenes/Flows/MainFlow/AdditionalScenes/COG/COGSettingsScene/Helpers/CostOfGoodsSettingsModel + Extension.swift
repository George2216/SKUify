//
//  CostOfGoodsSettingsModel + Extension.swift
//  SKUify
//
//  Created by George Churikov on 01.05.2024.
//

import Foundation
import Domain

extension CostOfGoodsSettingsModel {
    
    func toCOGSettingsItem() -> COGSettingsItem {
        .init(
            bundling: bundling,
            extraFee: extraFee,
            extraFeePerc: extraFeePerc,
            handling: handling,
            other: other,
            packaging: packaging,
            postage: postage,
            prepCentre: prepCentre,
            vatFreePostage: vatFreePostage
        )
    }
    
}
