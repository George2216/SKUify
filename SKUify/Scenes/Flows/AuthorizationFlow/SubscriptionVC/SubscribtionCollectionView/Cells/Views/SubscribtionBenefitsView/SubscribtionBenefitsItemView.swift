//
//  SubscribtionBenefitsItemView.swift
//  SKUify
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import UIKit
import SnapKit

final class SubscribtionBenefitsItemView: UIView {
    
    // MARK: - UI elements
    
    private lazy var checkImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    
    private lazy var contentStack = HorizontalStack()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentStack()
        setupCheckImageView()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set data

    func setupInput(_ input: Input) {
        titleLabel.text = input.title
    }
    
    // MARK: - Private methods

    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .medium,
            size: 12
        )
        titleLabel.textColor = .textColor
    }
    
    private func setupCheckImageView() {
        checkImageView.image = UIImage.check
        checkImageView.contentMode = .scaleAspectFit
    }
    
    private func setupContentStack() {
        contentStack.views = [
            checkImageView,
            titleLabel
        ]
        
        contentStack.alignment = .leading
        contentStack.distribution = .fillEqually
        
        addSubview(contentStack)
        
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

// MARK: - Input

extension SubscribtionBenefitsItemView {
    struct Input {
        let title: String
    }
    
}
