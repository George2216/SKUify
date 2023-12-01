//
//  UINavegationController.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import UIKit

extension UINavigationController {
    func addLeftBarIcon(image: UIImage) {
        let logoImageView = UIImageView.init(image: image)
        logoImageView.frame = CGRect(x:0.0,y:0.0, width:60,height:25.0)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 60)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  imageItem
    }
}
