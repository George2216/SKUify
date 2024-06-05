//
//  SubscribtionTitleView.swift
//  SKUify
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import SnapKit
import UIKit
import SDWebImage

final class SubscribtionTitleView: UIView {
    
    // MARK: - UI elements
    
    private lazy var titleImage = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var periodLabel = UILabel()
    
    private lazy var pricesStack = HorizontalStack()
    private lazy var contentStack = VerticalStack()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentStack()
        setupPricesStack()
        setupTitleImage()
        setupTitleLabel()
        setupSubtitleLabel()
        setupPriceLabel()
        setupPeriodLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set data
    
    func setupInput(_ input: Input) {
        titleImage.sd_setImage(with: input.imageURL)
        titleLabel.text = input.title
        subtitleLabel.text = input.subtitle
        priceLabel.text = input.price
        periodLabel.text = input.period
    }
    
    // MARK: - Private methods
    
    private func setupTitleImage() {
        titleImage.contentMode = .scaleAspectFit
        titleImage.snp.makeConstraints { make in
            make.size
                .equalTo(50)
        }
    }
    
    private func setupPeriodLabel() {
        periodLabel.font = .manrope(
            type: .bold,
            size: 15
        )
        periodLabel.textColor = .lightSubtextColor
    }
    
    private func setupPriceLabel() {
        priceLabel.font = .manrope(
            type: .extraBold,
            size: 32
        )
        priceLabel.textColor = .textColor
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.font = .manrope(
            type: .semiBold,
            size: 15
        )
        subtitleLabel.textColor = .primaryPurple
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .extraBold,
            size: 20
        )
        titleLabel.textColor = .primaryPurple
    }
    
    private func setupPricesStack() {
        pricesStack.views = [
            priceLabel,
            periodLabel
        ]
        
        pricesStack.spacing = 5.0
    }
    
    private func setupContentStack() {
        contentStack.views = [
            titleImage,
            titleLabel,
            subtitleLabel,
            pricesStack
        ]
        
        contentStack.alignment = .leading
        contentStack.distribution = .equalSpacing
        
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

// MARK: - Input

extension SubscribtionTitleView {
    struct Input {
        let imageURL: URL?
        let title: String
        let subtitle: String
        let price: String
        let period: String
    }
    
}
