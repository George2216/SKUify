//
//  UIView.swift
//  SKUify
//
//  Created by George Churikov on 27.11.2023.
//

import Foundation
import UIKit

extension UIView {
    func findFirstResponderTxtField() -> UITextField? {
        for subView in subviews {
            if subView.isFirstResponder {
                return subView as? UITextField
            }
            
            if let recursiveSubView = subView.findFirstResponderTxtField() {
                return recursiveSubView 
            }
        }
        
        return nil
    }
}
//
//extension UIView {
//    static func spacer(
//        size: CGFloat = .greatestFiniteMagnitude,
//        for layout: NSLayoutConstraint.Axis = .horizontal
//    ) -> UIView {
//        let spacer = UIView()
//
//        if layout == .horizontal {
//            let constraint = spacer.widthAnchor.constraint(equalToConstant: size)
//            constraint.priority = .defaultLow
//            constraint.isActive = true
//        } else {
//            let constraint = spacer.heightAnchor.constraint(equalToConstant: size)
//            constraint.priority = .defaultLow
//            constraint.isActive = true
//        }
//        return spacer
//    }
//
//}
