//
//  CustomActivityIndicator.swift
//  SKUify
//
//  Created by George Churikov on 25.11.2023.
//

import Foundation
import UIKit

final class CustomActivityIndicator: UIView {
    
    private let activityImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
