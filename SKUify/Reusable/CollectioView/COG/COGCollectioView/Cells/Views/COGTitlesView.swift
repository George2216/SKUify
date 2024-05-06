//
//  COGTitlesView.swift
//  SKUify
//
//  Created by George Churikov on 02.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class COGTitlesView: UIView {
    
    // MARK: - UI Elements
    
    private lazy var contentStack = VerticalStack()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
      
        setupContentStack()
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        setupContentStack(input)
    }
    
    // MARK: - Private methods
    
    private func setupContentStack(_ input: Input) {
        contentStack.views = input.content.map(makeContentItem)
    }
    
    private func makeContentItem(_ keyValue: KeyValue) -> UIView {
        let titleLabel = makeLabel(keyValue.title)
        let valueLabel = makeLabel(keyValue.value)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let stack = HorizontalStack()
        stack.spacing = 5.0
        stack.views = [
            titleLabel,
            valueLabel
        ]
        
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }
    
    
    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .manrope(
            type: .bold,
            size: 13
        )
        return label
    }
    
    private func setupContentStack() {
        contentStack.distribution = .fillEqually
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

// MARK: - Input

extension COGTitlesView {
    struct Input {
        let content: [KeyValue]
    }
    
    struct KeyValue {
        let title: String
        let value: String
    }
    
}
