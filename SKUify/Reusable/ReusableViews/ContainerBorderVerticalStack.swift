//
//  ContainerBorderVerticalStack.swift
//  SKUify
//
//  Created by George Churikov on 23.11.2023.
//

import Foundation
import UIKit

class ContainerBorderVerticalStack: VerticalStack {
    
    private func setupView() {
        backgroundColor = .cellColor
        layoutMargins = UIEdgeInsets(
            top: 20,
            left: 20,
            bottom: 20,
            right: 20
        )
        
        isLayoutMarginsRelativeArrangement = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.border.cgColor
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
