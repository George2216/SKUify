//
//  COGPurchaseDetailCell.swift
//  SKUify
//
//  Created by George Churikov on 02.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class COGPurchaseDetailCell: UICollectionViewCell {

    // MARK: UI elements

    private lazy var contentStack = VerticalStack()
    
    private let spacing: CGFloat = 10.0

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup views
    
    func setupInput(_ input: Input) {
        contentStack.views = input.content.map(makeView)
    }
    
    func setupWigth(_ width: CGFloat) {
        contentView.snp.makeConstraints { make in
            make.width
                .equalTo(width)
        }
    }
    
    // MARK: Private methods

    private func setupContentStack() {
        contentStack.spacing = spacing
        
        contentView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(spacing)
        }
    }
    
    private func setupCell() {
        backgroundColor = .cellColor
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    // MARK: - Factory methods
    
    private func makeView(_ input: COGPDViewType) -> UIView {
        switch input {
        case .titledView(let titledViewInput):
            return toDecoratedView(input: titledViewInput)
        }
    }
    
    private func toDecoratedView(input: COGPDTitledViewInput) -> UIView {
        let view = titledViewTypeToView(input.viewType)
        let decoratedView = HorizontalTitledView(
            title: input.title,
            decoratedView: view
        )
        return decoratedView
    }
    
    private func titledViewTypeToView(_ type: COGPDTitledViewType) -> UIView {
        switch type {
        case .textField(let config):
            let textField = DefaultTextField()
            textField.config = config

            textField.snp.makeConstraints { make in
                make.width
                    .equalTo(110)
            }
            return textField
            
        case .smallSwitch(let config):
            let smallSwitch = DefaultSmallSwitch()
            smallSwitch.config = config

            smallSwitch.snp.makeConstraints { make in
                make.width
                    .equalTo(50)
            }
            return smallSwitch
            
        case .button(let config):
            let button = DefaultButton()
            button.config = config
            button.snp.makeConstraints { make in
                make.width
                    .equalTo(120)
            }
            return button
        }
    }
    
}

// MARK: Input

extension COGPurchaseDetailCell {
    struct Input {
        let content: [COGPDViewType]
    }
    
}
