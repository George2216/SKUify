//
//  SmallSwitch.swift
//  SKUify
//
//  Created by George Churikov on 04.12.2023.
//

import Foundation
import UIKit

class SmallSwitch: UISwitch {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
}
