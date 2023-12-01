//
//  UIButton.swift
//  SKUify
//
//  Created by George Churikov on 29.11.2023.
//

import Foundation
import UIKit

extension UIButton.Configuration {
    mutating func setTitleFont(_ font: UIFont?) {
        titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer(
            { incoming in
                var outgoing = incoming
                outgoing.font = font
                return outgoing
            }
        )
    }
}

