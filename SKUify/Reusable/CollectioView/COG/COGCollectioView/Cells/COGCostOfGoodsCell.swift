//
//  COGCostOfGoodsCell.swift
//  SKUify
//
//  Created by George Churikov on 04.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class COGCostOfGoodsCell: UICollectionViewCell {
    
    // MARK: - UI elements
    
    private lazy var contentStack = VerticalStack()
    private lazy var contentTitleDecorator = TitleDecorator(
        decoratedView: contentStack,
        font: .manrope(
            type: .extraBold,
            size: 15
        ),
        textColor: .textColor
    )

    private let spacing: CGFloat = 10.0
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupContentStack()
        setupContentTitleDecorator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupInput(_ input: Input) {
        contentTitleDecorator.decorate(title: input.title)
        contentStack.views = input.content.map(makeView)
    }
    
    func setupWigth(_ width: CGFloat) {
        contentView.snp.makeConstraints { make in
            make.width
                .equalTo(width)
        }
    }
    
    // MARK: Private methods
    
    // MARK: Setup views

    private func setupContentStack() {
        contentStack.spacing = spacing
    }
    
    private func setupContentTitleDecorator() {
        contentView.addSubview(contentTitleDecorator)
        contentTitleDecorator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
                .inset(spacing)
        }
    }
    
    private func setupCell() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    // MARK: Factory methods

    private func makeView(_ type: COGCOfGViewType) -> UIView {
        switch type {
        case .titledView(let titledViewInput):
            return toDecoratedView(titledViewInput)
        case .titledViewsInLine(let titledViewInputs):
            return toDecoratedViews(titledViewInputs)
        case .buttons(let configs):
            return makeButtonsStack(configs)
        case .none:
            return UIView(frame: .zero)
        }
    }
    
    private func toDecoratedView(_ input: COGCOfGTitledViewInput) -> UIView {
        let view = titledViewTypeToView(input.viewType)
        let decoratedView = HorizontalTitledView(
            title: input.title,
            decoratedView: view
        )
        return decoratedView
    }
    
    private func toDecoratedViews(_ inputs: [COGCOfGTitledViewInput]) -> UIView {
        let hStack = HorizontalStack()
        hStack.views = inputs.map(toDecoratedView)
        hStack.spacing = spacing
        return hStack
    }
    
    private func titledViewTypeToView(_ type: COGCOfGTitledViewType) -> UIView {
        switch type {
        case .textField(let config):
            let textField = DefaultTextField()
            textField.config = config

            textField.snp.makeConstraints { make in
                make.width
                    .equalTo(110)
            }
            return textField
        }
    }
    
    private func makeButtonsStack(_ configs: [DefaultButton.Config]) -> UIView {
        let hStack = HorizontalStack()
        hStack.views = configs.map { $0.toButton() }
        hStack.spacing = 10
        return hStack
    }
    
}

// MARK: Input

extension COGCostOfGoodsCell {
    struct Input {
        let title: String
        var content: [COGCOfGViewType]
    }
    
}
