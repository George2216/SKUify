//
//  UILabel.swift
//  SKUify
//
//  Created by George Churikov on 03.07.2024.
//

import Foundation
import UIKit

extension UILabel {
    
    func halfTextColorChange(
        fullText: String,
        changeText: String,
        textColor: UIColor,
        font: UIFont
    ) {
        let strNumber: NSString = fullText as NSString
        let range = strNumber.range(of: changeText)

        let attribute = NSMutableAttributedString(string: fullText)
        attribute.addAttributes(
            [
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.font: font
            ],
            range: range
        )
        
        self.attributedText = attribute
    }
    
}
