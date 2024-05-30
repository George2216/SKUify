//
//  ExpensesPaginatedModel.swift
//  Domain
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation

public struct ExpensesPaginatedModel {
    public let limit = 10
    public var offset: Int? = nil
    
    public static func base() -> Self {
        .init()
    }
    
}
    
