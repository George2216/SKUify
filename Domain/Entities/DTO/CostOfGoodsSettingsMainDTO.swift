//
//  CostOfGoodsSettingsDTO.swift
//  Domain
//
//  Created by George Churikov on 29.04.2024.
//

import Foundation

public struct CostOfGoodsSettingsMainDTO: Codable {
    private let items: [CostOfGoodsSettingsHelperDTO]
    public let data: CostOfGoodsSettingsGroupedModel
    public let settingsType: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.settingsType = try container.decode(String.self, forKey: .settingsType)
        self.items = try container.decode([CostOfGoodsSettingsHelperDTO].self, forKey: .items)
        
        var itemsDistionary: [String: Double?] = [:]
        
        items.forEach { item in
            itemsDistionary[item.name] = item.value
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: itemsDistionary, options: .prettyPrinted)
            let data = try JSONDecoder().decode(CostOfGoodsSettingsGroupedModel.self, from: jsonData)
            self.data = data
        }
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case items
        case settingsType = "settings_type"
    }
    
}

 struct CostOfGoodsSettingsHelperDTO: Codable {
    let name: String
    let value: Double?
}

public struct CostOfGoodsSettingsGroupedModel: Codable {
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
    
    init(
        prepCentre: Double? = nil,
        bundling: Double? = nil,
        packaging: Double? = nil,
        extraFee: Double? = nil,
        extraFeePerc: Double? = nil,
        inboundShipping: Double? = nil,
        inboundShippingUnits: Double? = nil,
        vatFreePostage: Double? = nil,
        handling: Double? = nil,
        other: Double? = nil,
        postage: Double? = nil
    ) {
        self.prepCentre = prepCentre
        self.bundling = bundling
        self.packaging = packaging
        self.extraFee = extraFee
        self.extraFeePerc = extraFeePerc
        self.inboundShipping = inboundShipping
        self.inboundShippingUnits = inboundShippingUnits
        self.vatFreePostage = vatFreePostage
        self.handling = handling
        self.other = other
        self.postage = postage
    }
    
}

