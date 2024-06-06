//
//  OnlyIdDTO.swift
//  Domain
//
//  Created by George Churikov on 16.04.2024.
//

import Foundation

// We use it when the parameters do not matter. We only use the ID parameter to make sure that an error has not arrived
public struct OnlyIdDTO: Decodable {
    private let id: Int
}
