//
//  ExpenseDTOExtension.swift
//  SKUify
//
//  Created by George Churikov on 24.05.2024.
//

import Foundation
import Domain

extension ExpenseDTO {
    
    private static let emptyCategoryId = -100
    
    static func base() -> Self {
        .init(
            name: "",
            categoryId: emptyCategoryId,
            method: CalculationMethod.allCases[0].key,
            interval: PeriodType.allCases[0].key,
            startDate: Date().ddMMyyyyString("/"),
            endDate: nil,
            amount: 0.0,
            vat: 0.0
        )
    }
    
    func error() -> Error? {
        var errorMessages: [String] = []
        if name.isEmpty {
            errorMessages.append("Name is required")
        }
        
        if categoryId == Self.emptyCategoryId {
            errorMessages.append("Category is required")
        }
        
        guard !errorMessages.isEmpty else { return nil }
        
        return CustomError(message: errorMessages.joined(separator: "\n"))
    }
    
}
