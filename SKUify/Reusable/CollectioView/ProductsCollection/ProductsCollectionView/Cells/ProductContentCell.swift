//
//  ProductContentCell.swift
//  SKUify
//
//  Created by George Churikov on 11.03.2024.
//

import UIKit
import SnapKit

final class ProductContentCell: UICollectionViewCell {
    
    // Containers
    private lazy var firstRowStack = VerticalStack()
    private lazy var secondRowStack = VerticalStack()
    private lazy var thirdRowStack = VerticalStack()
    private lazy var contentStack = HorizontalStack()
    
    private lazy var containerView = UIView()
    
    private let titleLabel = UILabel()
    
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
    
    // MARK: - Change height
    
    private func updateAppearance() {
        self.collapsedConstraint.isActive = !self.isSelected
        self.expandedConstraint.isActive = self.isSelected
    }
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .cellColor

        setupRowStacks()
        setupContainerView()
        makeTitleLabel()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupWigth(_ width: CGFloat) {
        contentView.snp.makeConstraints { make in
            make.width
                .equalTo(width)
            make.edges
                .equalToSuperview()
        }
    }
    
    func setupInput(_ input: Input) {
        titleLabel.text = input.title
        firstRowStack.views = inputToViews(items: input.firstRow)
        secondRowStack.views = inputToViews(items: input.secondRow)
        thirdRowStack.views = inputToViews(items: input.thirdRow)
    }
    
    private func setupRowStacks() {
        [
            firstRowStack,
            secondRowStack,
            thirdRowStack
        ]
            .forEach { stack in
                stack.alignment = .fill
                stack.distribution = .fillEqually
                stack.spacing = 5
            }
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            collapsedConstraint = make.bottom
                .equalTo(contentView.snp.top)
                .constraint
            collapsedConstraint.layoutConstraints.first?.priority = .defaultHigh
        }
    }
    
    private func makeTitleLabel() {
        titleLabel.font = .manrope(
            type: .bold,
            size: 15.0
        )
        titleLabel.textColor = .textColor
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top
                .horizontalEdges
                .equalToSuperview()
                .inset(10)
        }
    }
    
    private func setupContentStack() {
        contentStack.views = [
            firstRowStack,
            secondRowStack,
            thirdRowStack
        ]
        contentStack.alignment = .fill
        contentStack.distribution = .equalSpacing
        
        contentStack.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 10,
            right: 10
        )
        contentStack.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
            make.horizontalEdges
                .equalToSuperview()
        }
        contentStack.snp.prepareConstraints { make in
            expandedConstraint = make.bottom
                .equalToSuperview()
                .constraint
            
            expandedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
    }
    
}

// MARK: Factory methods

extension ProductContentCell {
    private func makeProductLabel(text: String) -> UIView {
        let label = UILabel()
        label.font = .manrope(
            type: .bold,
            size: 15
        )
        label.text = text
        label.textColor = .textColor
        return label
    }
    
    private func makeProductButton(config: DefaultButton.Config) -> UIView {
        let defaultButton = DefaultButton()
        defaultButton.config = config
        defaultButton.contentHorizontalAlignment = .left
        defaultButton.contentMode = .scaleAspectFit
        return defaultButton
    }
    
    private func makeProductImage(_ imageType: ProductCellImageType) -> UIView {
        let imageView = UIImageViewAligned()
        imageView.contentMode = .scaleAspectFit
        imageView.alignment = .left
        imageView.image = imageType.image

        return imageView
    }
    
    private func makeAddInfoView(_ input: ProductAddInfoView.Input) -> UIView {
        let addInfoView = ProductAddInfoView()
        addInfoView.setupInput(input)
        return addInfoView
    }
    
    private func makeTitledMarketplace(_ input: TitledMarketplace.Input) -> UIView {
        let titledMarketplace = TitledMarketplace()
        titledMarketplace.setInput(input)
        return titledMarketplace
    }
    
    private func makeSpacer() -> UIView {
        return UIView.spacer(for: .vertical)
    }
    
    private func makeView(by type: ProductViewType) -> UIView {
        switch type {
        case .text(let text):
            return makeProductLabel(text: text)
        case .button(let config):
            return makeProductButton(config: config)
        case .image(let imageType):
            return makeProductImage(imageType)
        case .titledMarketplace(let input):
            return makeTitledMarketplace(input)
        case .addInfo(let input):
            return makeAddInfoView(input)
        case .spacer:
            return makeSpacer()
        }
    }
    
    private func toDecoratedView(input: ProductViewInput) -> UIView {
        let view = makeView(by: input.viewType)
        let viewWithSpacing = HorizontalStack()
        viewWithSpacing.views = [
            view,
            UIView()
        ]
        
        viewWithSpacing.snp.makeConstraints { make in
            make.height
                .equalTo(22)
        }
        
        let decorator = TitleDecorator(decoratedView: viewWithSpacing)
        decorator.decorate(title: input.title)
        return decorator
    }
    
    private func inputToViews(items: [ProductViewInput]) -> [UIView] {
        items.map { [weak self] input in
            guard let self else {
                return UIView()
            }
            return self.toDecoratedView(input: input)
        }
    }
    
}

// MARK: - Input

extension ProductContentCell {
    struct Input {
        var title: String = ""
        let firstRow: [ProductViewInput]
        let secondRow: [ProductViewInput]
        let thirdRow: [ProductViewInput]
    }
    
}
