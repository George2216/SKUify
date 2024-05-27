//
//  ExpensesCategoryDTO.swift
//  Domain
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation

public struct ExpensesCategoryDTO: Decodable {
    public let id: Int
    public let name: String
    
    public init(
        id: Int,
        name: String
    ) {
        self.id = id
        self.name = name
    }
    
}

extension ExpensesCategoryDTO: Equatable {
    public static func != (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
}
