//
//  SalesOriginalPriceDTO.swift
//  Domain
//
//  Created by George Churikov on 12.02.2024.
//

import Foundation

public struct SalesOriginalPriceDTO: Decodable {
    public let price: Double
    public let currency: String
}
