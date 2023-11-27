//
//  Fonts.swift
//  SKUify
//
//  Created by George Churikov on 21.11.2023.
//

import Foundation
import UIKit

extension UIFont {
    static func manrope(type: ManropeFontType, size: CGFloat) -> UIFont? {
        UIFont(name: "Manrope-\(type.typeName)", size: size)
    }
    
    enum ManropeFontType: String {
        case regular
        case extraLight
        case light
        case medium
        case semiBold
        case bold
        case extraBold
        
        fileprivate var typeName: String {
            rawValue.capitalized
        }
    }
}
