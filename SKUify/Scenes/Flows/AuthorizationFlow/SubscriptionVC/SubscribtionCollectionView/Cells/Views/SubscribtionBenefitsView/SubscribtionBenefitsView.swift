//
//  SubscribtionBenefitsView.swift
//  SKUify
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import UIKit
import SnapKit

final class SubscribtionBenefitsView: UIView {
    
    // MARK: - UI elements
    
    private lazy var contentStack = VerticalStack()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set data

    func setupInput(_ input: Input) {
        contentStack.views = input.benefits.map({ input in
            let item = SubscribtionBenefitsItemView()
            item.setupInput(input)
            return item
        })
    }
    
    // MARK: - Private methods

    private func setupContentStack() {
        contentStack.distribution = .equalSpacing
        contentStack.spacing = 10
        
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

// MARK: - Input

extension SubscribtionBenefitsView {
    struct Input {
        let benefits: [SubscribtionBenefitsItemView.Input]
    }
    
}
