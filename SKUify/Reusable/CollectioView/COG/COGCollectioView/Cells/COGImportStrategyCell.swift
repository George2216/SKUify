//
//  COGToApplyToAsinCell.swift
//  SKUify
//
//  Created by George Churikov on 01.05.2024.
//

import Foundation
import UIKit
import SnapKit

final class COGImportStrategyCell: UICollectionViewCell {

    // MARK: UI elements
    
    private lazy var contentStack = VerticalStack()
    
    private let spacing: CGFloat = 10.0
    
  
    // MARK: - Initializers

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
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    // MARK: - Factory methods
    
    private func makeView(_ input: COGToApplyToAsinCellViewType) -> UIView {
        switch input {
        case .titledSwith(let input):
            return makeTitledSwith(input)
        case .titledViews(let input):
            return makeTitledViews(input)
        }
    }
    
    private func makeTitledSwith(_ input: COGImportStrategyCellTitledSwithInput) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = input.title
        titleLabel.font = .manrope(
            type: .extraBold,
            size: 20
        )
        let smallSwith = DefaultSmallSwitch()
        smallSwith.config = input.config
        
        let stack = HorizontalStack()
        stack.views = [
            titleLabel,
            UIView.spacer(),
            smallSwith
        ]
        
        return stack
    }
    
    private func makeTitledViews(_ inputs: [COGImportStrategyCellTitledViewInput]) -> UIView {
        let stack = VerticalStack()
        stack.views = inputs.map { input  in
            let decorator = TitleDecorator(
                decoratedView: makeTitledSubviews(input.viewType),
                font: .manrope(
                    type: .extraBold,
                    size: 15
                ),
                textColor: .textColor,
                spacing: spacing
            )
            decorator.decorate(title: input.title)
            return decorator
        }
        
        return stack
    }
    
    private func makeTitledSubviews(_ input: COGImportStrategyCellTitledSubviewType) -> UIView {
        switch input {
        case .titledLabels(let inputs):
            return makeTitledLabelsView(
                inputs,
                isBold: false
            )
        case .boldTitledLabels(let inputs):
            return makeTitledLabelsView(
                inputs,
                isBold: true
            )
        }
        
    }
    
    private func makeTitledLabelsView(
        _ inputs: [COGImportStrategyCellTitledTextInput],
        isBold: Bool
    ) -> UIView {
                
        var views = inputs
            .map { input in
                return makeTitledLabel(
                    input, isBold: isBold
                )
            }
        
        if isBold {
            views = views.flatMap { [makeSeparator(), $0] } + [makeSeparator()]
        } else {
            views.insert(
                makeSeparator(),
                at: 0
            )
        }
        
        let stack = VerticalStack()
        stack.views = views
        stack.spacing = 5.0
        return stack
    }
    
    private func makeTitledLabel(
        _ input: COGImportStrategyCellTitledTextInput,
        isBold: Bool
    ) -> UIView {
        
        let font: UIFont = isBold ?
            .manrope(
                type: .extraBold,
                size: 15
            ) :
            .manrope(
                type: .semiBold,
                size: 15
            )
        
        let titleLabel = UILabel()
        titleLabel.text = input.title
        titleLabel.font = font
        
        let valueLabel = UILabel()
        valueLabel.text = input.value
        valueLabel.font = font
        
        let stack = HorizontalStack()
        stack.views = [
            titleLabel,
            UIView.spacer(),
            valueLabel
        ]
        stack.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
        return stack
    }
    
    private func makeSeparator() -> UIView {
        let separatorView = UIView()
        separatorView.backgroundColor = .background
        
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return separatorView
    }
    
   
}

// MARK: - Input

extension COGImportStrategyCell {
    struct Input {
        let content: [COGToApplyToAsinCellViewType]
    }
    
}
