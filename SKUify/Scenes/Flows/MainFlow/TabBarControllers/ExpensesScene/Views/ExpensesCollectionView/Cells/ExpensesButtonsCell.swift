//
//  ExpensesButtonsCell.swift
//  SKUify
//
//  Created by George Churikov on 07.05.2024.
//

import Foundation
import UIKit
import SnapKit

final class ExpensesButtonsCell: UICollectionViewCell {
    
    // MARK: - UI elements

    private lazy var contentStack = HorizontalStack()
    
    private let spacing: CGFloat = 10.0

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup views

    func setupInput(_ input: Input) {
        setupContentStack(input)
    }
    
    func setupWigth(_ width: CGFloat) {
        contentView.snp.makeConstraints { make in
            make.width
                .equalTo(width)
        }
    }
    
    // MARK: - Private methods

    private func setupContentStack(_ input: Input) {
        var views: [UIView] = input.configs
            .map { $0.toButton() }
//        views.append(UIView.spacer())
        contentStack.views = views
    }
    
    private func setupContentStack() {
        contentStack.spacing = spacing
        
        contentView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(spacing)
        }
    }
    
}

// MARK: Input

extension ExpensesButtonsCell {
    struct Input {
        var configs: [DefaultButton.Config]
    }
    
}
