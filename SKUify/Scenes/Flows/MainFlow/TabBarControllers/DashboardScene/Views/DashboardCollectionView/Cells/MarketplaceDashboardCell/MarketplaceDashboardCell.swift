//
//  MarketplaceDashboardCell.swift
//  SKUify
//
//  Created by George Churikov on 03.12.2023.
//

import UIKit
import SnapKit

final class MarketplaceDashboardCell: UICollectionViewCell {
    
    // MARK: UIElements
    
    private lazy var topView = MarketplaceDashboardCellTopView()
    
    // Decorator for topView. This adds the main label
    private lazy var topViewDecorator = TitleDecorator(
        decoratedView: topView,
        font: .manrope(
            type: .extraBold,
            size: 20
        ),
        textColor: .textColor
    )
    private lazy var marketplaceContent = MarketplaceDashboardCellContentView()
    private lazy var mainContainer = UIView()
    private lazy var separatorView = UIView()
    
    // MARK: Contraints
    
    // Constraint for extended condition
    private var expandedConstraint: Constraint!
    
    // Constraint for collapsed condition
    private var collapsedConstraint: Constraint!
    
    // Update appearance by isSelected cahnged
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // Default padding
    private let padding: CGFloat = 10.0
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupMainContainer()
        setupTopView()
        setupContentView()
        setupSeparatorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInput(_ input: Input) {
        topViewDecorator.decorate(title: input.title)
        topView.setInput(input.topViewInput)
        marketplaceContent.setupInput(input.contentInput)
        setupCornerRadius(input)
    }
    
    private func setupCornerRadius(_ input: Input) {
        let maskCorners: CACornerMask =
        input.isTopCell ? [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        : input.isBottomCell ? [
            .layerMaxXMaxYCorner,
            .layerMinXMaxYCorner
        ]
        : []
        layer.maskedCorners = maskCorners
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    
    private func updateAppearance() {
        collapsedConstraint.isActive = !isSelected
        expandedConstraint.isActive = isSelected
        topView.isSelected = isSelected
    }
    
    //MARK: - Setup view

    private func setupSeparatorView() {
        separatorView.backgroundColor = .background
        mainContainer.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.horizontalEdges
                .equalToSuperview()
                .inset(padding)
            make.height
                .equalTo(1)
            make.bottom
                .equalToSuperview()
                .inset(1)
        }
    }
    
    private func setupContentView() {
        mainContainer.addSubview(marketplaceContent)
        marketplaceContent.snp.makeConstraints { make in
            make.top
                .equalTo(topViewDecorator.snp.bottom)
                .offset(padding)

            make.horizontalEdges
                .equalToSuperview()
                .inset(padding)

        }
        
        marketplaceContent.snp.prepareConstraints { make in
            expandedConstraint = make.bottom
                .equalToSuperview()
                .constraint
            expandedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
    }
    
    private func setupTopView() {
        mainContainer.addSubview(topViewDecorator)
        topViewDecorator.snp.makeConstraints { make in
            make.top
                .directionalHorizontalEdges
                .equalToSuperview()
                .inset(padding)
        }
        
        topViewDecorator.snp.prepareConstraints { make in
            collapsedConstraint = make.bottom
                .equalToSuperview()
                .inset(padding)
                .constraint
            collapsedConstraint.layoutConstraints.first?.priority = .defaultHigh
        }
    }
    
    private func setupMainContainer() {
        contentView.addSubview(mainContainer)
        mainContainer.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
        
    private func setupView() {
        backgroundColor = .cellColor
        clipsToBounds = true
    }
    
}

// MARK: - Input

extension MarketplaceDashboardCell {
    struct Input {
        var title: String?
        var isTopCell: Bool = false
        var isBottomCell: Bool = false
        let topViewInput: MarketplaceDashboardCellTopView.Input
        let contentInput: MarketplaceDashboardCellContentView.Input
    }
    
}

