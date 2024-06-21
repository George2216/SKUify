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

extension UIView {
    func centerOfView() -> CGPoint {
        self.superview?
            .convert(
                self.center,
                to: nil
            ) ?? CGPoint.zero
    }
    
}

extension UIView {
    static func spacer(
        size: CGFloat = .greatestFiniteMagnitude,
        for layout: NSLayoutConstraint.Axis = .vertical
    ) -> UIView {
        let spacer = UIView()
        
        if layout == .horizontal {
            let constraint = spacer.widthAnchor
                .constraint(equalToConstant: size)
            constraint.priority = .defaultLow
            constraint.isActive = true
        } else {
            let constraint = spacer.heightAnchor
                .constraint(equalToConstant: size)
            constraint.priority = .defaultLow
            constraint.isActive = true
        }
        return spacer
    }
    
}

extension UIView {
    func roundCorners(
        corners: UIRectCorner,
        radius: CGFloat
    ) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: radius,
                height: radius
            )
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}
