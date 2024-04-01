//
//  UITextField.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import Foundation
import UIKit
import SnapKit

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
    
    func addRightImage(
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
        
        self.rightView = containerView
        self.rightViewMode = .always
    }
    
}

extension UITextField {
    func addLeftText(
        _ text: String = "",
        font: UIFont = .manrope(
            type: .bold,
            size: 13
        ),
        padding: CGFloat = 12
    ) {
        let label = UILabel()
        label.textAlignment = .center
        label.text = text
        label.font = font
        let containerView = UIView()
        containerView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading
                .equalToSuperview()
                .offset(padding)
            make.verticalEdges
                .trailing
                .equalToSuperview()
        }
        
        self.leftView = containerView
        self.leftViewMode = .always
    }
    
}
