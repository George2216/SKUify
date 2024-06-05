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
    
    // MARK: - UI elements
    
    private lazy var titleView = SubscribtionTitleView()
    private lazy var benefitsView = SubscribtionBenefitsView()
    private lazy var subscribeButton = DefaultButton()
    
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
        titleView.setupInput(input.titleViewInput)
        benefitsView.setupInput(input.benifistsInput)
        subscribeButton.config = input.subscribeButtonConfig
    }
    
    // MARK: - Private methods

    private func setupContentStack() {
        contentStack.views = [
            titleView,
            benefitsView,
            subscribeButton
        ]
        
        contentStack.alignment = .leading
        contentStack.distribution = .equalSpacing
        
        contentView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
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
