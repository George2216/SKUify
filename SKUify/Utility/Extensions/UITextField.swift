//
//  UITextField.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import Foundation
import UIKit

extension UITextField {
    func addLeftImage(
        _ image: UIImage = UIImage(),
        padding: CGFloat = 12
    ) {
        let containerView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: image.size.width + padding,
                height: frame.height 
            )
        )
        
        let imageView = UIImageView(
            frame: CGRect(
                x: padding,
                y: 0,
                width: image.size.width,
                height: frame.height
            )
        )
        
        imageView.image = image
        imageView.contentMode = .center
        containerView.addSubview(imageView)
        
        self.leftView = containerView
        self.leftViewMode = .always
    }
}
