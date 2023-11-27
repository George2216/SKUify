//
//  CALayer.swift
//  SKUify
//
//  Created by George Churikov on 22.11.2023.
//

import Foundation
import UIKit

extension CALayer {
    func reset() {
        borderColor = nil
        borderWidth = 0.0
        cornerRadius = 0.0
        shadowRadius = 0.0
        shadowColor = nil
        shadowOffset = .zero
    }
}
