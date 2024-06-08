//
//  CATransition.swift
//  SKUify
//
//  Created by George Churikov on 26.03.2024.
//

import Foundation
import UIKit

extension CATransition {
    static func alertTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        return transition
    }
    
}
