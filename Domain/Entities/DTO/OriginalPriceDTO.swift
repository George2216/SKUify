//
//  OriginalPriceDTO.swift
//  Domain
//
//  Created by George Churikov on 12.02.2024.
//

import Foundation

public struct OriginalPriceDTO: Decodable {
    public let price: Double
    public let currency: String
}
