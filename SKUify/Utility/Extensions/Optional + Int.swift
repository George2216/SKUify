//
//  Optional + Int.swift
//  SKUify
//
//  Created by George Churikov on 18.04.2024.
//

import Foundation

extension Optional where Wrapped == Int {
    func stringOrEmpty() -> String {
        guard let value = self else {
            return ""
        }
        return String(value)
    }
    
}
