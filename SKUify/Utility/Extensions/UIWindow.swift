//
//  UIWindow.swift
//  SKUify
//
//  Created by George Churikov on 29.11.2023.
//

import Foundation
import UIKit

extension UIWindow {
    static var key: UIWindow! {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
