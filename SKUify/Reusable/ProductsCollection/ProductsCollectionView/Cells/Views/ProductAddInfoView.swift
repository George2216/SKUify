//
//  ProductAdd.swift
//  SKUify
//
//  Created by George Churikov on 11.03.2024.
//

import Foundation
import UIKit
import SnapKit

final class ProductAddInfoView: UIView {
    
    // MARK: UI elements

    private lazy var vatButton = DefaultButton()
    private lazy var sellerCentralButton = DefaultButton()
    private lazy var amazonButton = DefaultButton()

    private lazy var contentStack = HorizontalStack()
    
    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        vatButton.config = input.vatButtonConfig
        sellerCentralButton.config = input.sellerCentralButtonConfig
        amazonButton.config = input.amazonButtonConfig
    }
    
    private func setupContentStack() {
        contentStack.views = [
            vatButton,
            sellerCentralButton,
            amazonButton
        ]
        contentStack.spacing = 3.0
        
        addSubview(contentStack)
        contentStack.distribution = .fill
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

// MARK: Input

extension ProductAddInfoView {
    struct Input {
        var vatButtonConfig: DefaultButton.Config
        var sellerCentralButtonConfig: DefaultButton.Config
        var amazonButtonConfig: DefaultButton.Config
    }
    
}

