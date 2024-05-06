//
//  Double.swift
//  SKUify
//
//  Created by George Churikov on 11.03.2024.
//

import Foundation

extension Double {

    func toString() -> String {
        return String(
            format: "%.2f",
            self
        )
    }
    
}

