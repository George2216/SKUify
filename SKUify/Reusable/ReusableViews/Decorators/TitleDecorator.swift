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
    
    private weak var decoratedView: UIView?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: axis)
        label.setContentCompressionResistancePriority(.defaultHigh, for: axis)
        return label
    }()
    
    private let axis: NSLayoutConstraint.Axis
    
    // MARK: - Initializers
    
    init(
        decoratedView: UIView,
        font: UIFont = .manrope(
            type: .bold,
            size: 12
        ),
        textColor: UIColor = .subtextColor,
        spacing: CGFloat = 0.0,
        titleAligment: NSTextAlignment = .left,
        numberOfLines: Int = 1,
        axis: NSLayoutConstraint.Axis = .vertical
    ) {
        self.decoratedView = decoratedView
        self.axis = axis
        super.init(frame: .zero)
        setupStack(decoratedView, spacing: spacing)
        setupDecoratedView(decoratedView)
        setupTitleAttributed(font: font, textColor: textColor, titleAligment: titleAligment, numberOfLines: numberOfLines)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleAttributed(font: UIFont, textColor: UIColor, titleAligment: NSTextAlignment, numberOfLines: Int) {
        titleLabel.font = font
        titleLabel.textColor = textColor
        titleLabel.textAlignment = titleAligment
        titleLabel.numberOfLines = numberOfLines
    }
    
    private func setupStack(_ decoratedView: UIView, spacing: CGFloat) {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, decoratedView])
        stackView.axis = axis
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = spacing
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
        
    private func setupDecoratedView(_ decoratedView: UIView) {
        decoratedView.setContentHuggingPriority(.defaultHigh, for: axis)
        decoratedView.setContentCompressionResistancePriority(.defaultHigh, for: axis)
    }
    
}

// MARK: - Protocol execution

extension TitleDecorator: TitleDecoratorProtocol {
    func decorate(title: String?) {
        guard titleLabel.text != title else { return }
        titleLabel.text = title
    }
}
