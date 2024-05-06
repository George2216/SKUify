//
//  BreakEvenPointDTO.swift
//  Domain
//
//  Created by George Churikov on 11.04.2024.
//

import Foundation

public struct BreakEvenPointDTO: Decodable {
    public let breakPointEven: Double?
    
    private enum CodingKeys: String, CodingKey {
        case breakPointEven = "break_point_even"
    }
    
}
