//
//  Double.swift
//  SKUify
//
//  Created by George Churikov on 11.03.2024.
//

import Foundation

extension Double {
    func toDecimalString(decimal: Int) -> String {
        String(
            format: "%.\(decimal)f",
            self
        )
    }
}
