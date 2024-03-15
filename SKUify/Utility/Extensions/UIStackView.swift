//
//  UIStackView.swift
//  SKUify
//
//  Created by George Churikov on 13.03.2024.
//

import Foundation
import UIKit

extension UIStackView {
    
    func setPagging(_ padding: CGFloat) {
        layoutMargins = .init(
            top: padding,
            left: padding,
            bottom: padding,
            right: padding
        )
        isLayoutMarginsRelativeArrangement = true
    }
    
}
