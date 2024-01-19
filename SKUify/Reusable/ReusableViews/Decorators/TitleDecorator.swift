//
//  LightTitleDecorator.swift
//  SKUify
//
//  Created by George Churikov on 11.12.2023.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Decorator protocol

protocol TitleDecoratorProtocol {
    func decorate(title: String?)
}

final class TitleDecorator: UIView {
    
    // MARK: - UIElements
    
    private let decoratedView: UIView
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Initializers
    
    init(
        decoratedView: UIView,
        font: UIFont = .manrope(
            type: .bold,
            size: 12
        ),
        textColor: UIColor = .subtextColor,
        numberOfLines: Int = 0
    ) {
        self.decoratedView = decoratedView
        super.init(frame: .zero)
        setupStack()
        setupTitleLabel()
        setupDecoratedView()
        setupTitleAttributed(
            font: font,
            textColor: textColor,
            numberOfLines: numberOfLines
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleAttributed(
        font: UIFont,
        textColor: UIColor,
        numberOfLines: Int
    ) {
        titleLabel.font = font
        titleLabel.textColor = textColor
        titleLabel.numberOfLines = numberOfLines
    }
    
    private func setupStack() {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                decoratedView
            ]
        )
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }

    }
    
    private func setupTitleLabel() {
        titleLabel.setContentHuggingPriority(
            .defaultHigh,
            for: .vertical
        )
        titleLabel.setContentCompressionResistancePriority(
            .defaultLow,
            for: .vertical
        )
    }
    
    private func setupDecoratedView() {
        decoratedView.setContentHuggingPriority(
            .defaultLow,
            for: .vertical
        )
        decoratedView.setContentCompressionResistancePriority(
            .defaultHigh,
            for: .vertical
        )
    }
    
}

// MARK: - Protocol execution

extension TitleDecorator: TitleDecoratorProtocol {
    func decorate(title: String?) {
        titleLabel.text = title
    }
    
}
