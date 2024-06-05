//
//  SubscribtionCell.swift
//  SKUify
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import UIKit
import SnapKit

final class SubscribtionCell: UICollectionViewCell {
    
    // MARK: Internal properties
    
    var layoutSizeFitting: CGSize {
        contentStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    // MARK: - UI elements
    
    private lazy var scrollDecorator = ScrollDecorator(contentView)
    private lazy var containerView = scrollDecorator.containerView
    
    private lazy var titleView = SubscribtionTitleView()
    private lazy var benefitsView = SubscribtionBenefitsView()
    private lazy var subscribeButton = DefaultButton()
    
    private lazy var contentStack = VerticalStack()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set data

    func setupInput(_ input: Input) {
        titleView.setupInput(input.titleViewInput)
        benefitsView.setupInput(input.benifistsInput)
        subscribeButton.config = input.subscribeButtonConfig
    }
    
    func setupWidth(_ width: CGFloat) {
        contentView.snp.makeConstraints { make in
            make.width
                .equalTo(width)
            make.edges
                .equalToSuperview()
        }
    }
    
    // MARK: - Private methods
    
    private func makeSeparatorLine() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .background
        separator.snp.makeConstraints { make in
            make.height
                .equalTo(1)
        }
        return separator
    }

    private func setupContentStack() {
        contentStack.views = [
            titleView,
            makeSeparatorLine(),
            benefitsView,
            subscribeButton
        ]
        
        contentStack.spacing = 10
        contentStack.distribution = .equalSpacing
        contentStack.layoutMargins = UIEdgeInsets(
            top: 10,
            left: 10, 
            bottom: 10,
            right: 10
        )
        contentStack.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
    private func setupCell() {
        backgroundColor = .white
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.border.cgColor
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
}

// MARK: - Input

extension SubscribtionCell {
    struct Input {
        let titleViewInput: SubscribtionTitleView.Input
        let benifistsInput: SubscribtionBenefitsView.Input
        let subscribeButtonConfig: DefaultButton.Config
    }
    
}
