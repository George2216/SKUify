//
//  CostOfGoodsSettingsDTO.swift
//  Domain
//
//  Created by George Churikov on 29.04.2024.
//

import Foundation

public struct CostOfGoodsSettingsMainDTO: Decodable {
    // Need only for decoding
    private let items: [CostOfGoodsSettingsHelperDTO]
    // Decoded items
    public let data: CostOfGoodsSettingsModel
    public let settingsType: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.settingsType = try container.decode(String.self, forKey: .settingsType)
        self.items = try container.decode([CostOfGoodsSettingsHelperDTO].self, forKey: .items)
        
        // Convert items to dictionary
        var itemsDistionary: [String: Double?] = [:]
        
        items.forEach { item in
            itemsDistionary[item.name] = item.value
        }
        // Convert itemsDistionary to itemsJsonData

        let itemsJsonData = try JSONSerialization.data(withJSONObject: itemsDistionary, options: .prettyPrinted)
        // Convert itemsJsonData to CostOfGoodsSettingsModel

        let data = try JSONDecoder().decode(CostOfGoodsSettingsModel.self, from: itemsJsonData)
        
        self.data = data
    }
    
    private enum CodingKeys: String, CodingKey {
        case items
        case settingsType = "settings_type"
    }
    
}


public struct CostOfGoodsSettingsModel: Decodable {
    public let bundling: Double?
    public let extraFee: Double?
    public let extraFeePerc: Double?
    public let handling: Double?
    public let other: Double?
    public let packaging: Double?
    public let postage: Double?
    public let prepCentre: Double?
    public let vatFreePostage: Double?
    public let inboundShipping: Double?
    public let inboundShippingUnits: Double?
    
    
    private enum CodingKeys: String, CodingKey {
        case bundling
        case extraFee = "extra_fee"
        case extraFeePerc = "extra_fee_perc"
        case handling
        case other
        case packaging
        case postage
        case prepCentre = "prep_centre"
        case vatFreePostage = "vat_free_postage"
        case inboundShipping = "inbound_shipping"
        case inboundShippingUnits = "inbound_shipping_units"
    }
    
}

// MARK: - Helper model

struct CostOfGoodsSettingsHelperDTO: Codable {
   let name: String
   let value: Double?
    
}
