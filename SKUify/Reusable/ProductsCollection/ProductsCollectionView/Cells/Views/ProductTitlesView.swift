//
//  ProductTitlesView.swift
//  SKUify
//
//  Created by George Churikov on 12.02.2024.
//

import Foundation
import UIKit
import SnapKit

final class ProductTitlesView: UIView {
    
    // MARK: - UI Elements
    
    private lazy var titlesStack = VerticalStack()
    private lazy var valuesStack = VerticalStack()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupTitlesStack()
        setupValuesStack()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        setupTitlesStack(input)
        setupValuesStack(input)

    }
    
    private func setupTitlesStack(_ input: Input) {
        titlesStack.views = input.content
            .map { $0.title }
            .map { makeLabel($0) }
    }
    
    private func setupValuesStack(_ input: Input) {
        valuesStack.views = input.content
            .map { $0.value }
            .map { makeLabel($0) }
    }
    
    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .left
        label.font = .manrope(
            type: .bold,
            size: 13
        )
        return label
    }
    
    private func setupTitlesStack() {
        titlesStack.alignment = .leading
        titlesStack.distribution = .equalSpacing
        
        addSubview(titlesStack)
        titlesStack.snp.makeConstraints { make in
            make.verticalEdges
                .equalToSuperview()
            make.leading
                .equalToSuperview()
        }
    }

    private func setupValuesStack() {
        valuesStack.alignment = .leading
        valuesStack.distribution = .equalSpacing
        addSubview(valuesStack)
        valuesStack.snp.makeConstraints { make in
            make.verticalEdges
                .equalToSuperview()
            make.leading
                .equalTo(titlesStack.snp.trailing)
                .offset(10)
            make.trailing
                .equalToSuperview()
                .priority(.low)
        }
    }
    
}

// MARK: - Input

extension ProductTitlesView {
    struct Input {
        let content: [KeyValue]
    }
    
    struct KeyValue {
        let title: String
        let value: String
    }
}
