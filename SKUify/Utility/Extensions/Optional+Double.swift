//
//  Optional+Double.swift
//  SKUify
//
//  Created by George Churikov on 08.04.2024.
//

import Foundation

extension Optional where Wrapped == Double {
    func toUnwrappedString() -> String {
        guard let value = self else {
            return "0.00"
        }
        return String(format: "%.2f", value)
    }
    
    func valueOrZero() -> Double {
        guard let self else { return 0.00 }
        return self
    }
    
}
