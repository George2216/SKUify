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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        
        setupRowStacks()
        setupContainerView()
        setupContentStack()

        
        
    }
    
    //MARK: - Initializers
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
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
        let firstRow = input.firstRow
        let secondRow = input.secondRow
        let thirdRow = input.thirdRow
        
        firstRowStack.views = inputToViews(items: firstRow)
        secondRowStack.views = inputToViews(items: secondRow)
        thirdRowStack.views = inputToViews(items: thirdRow)
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
            }
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
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
            make.top.equalToSuperview()
            make.horizontalEdges
                .equalToSuperview()
        }
        
        contentStack.snp.prepareConstraints { make in
            expandedConstraint = make.bottom
                .equalToSuperview()
                .constraint
            
            expandedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
        
        containerView.snp.makeConstraints { make in
            collapsedConstraint = make.bottom
                .equalTo(contentView.snp.top)
                .constraint
            collapsedConstraint.layoutConstraints.first?.priority = .defaultHigh
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
    
    private func makeProductButton(config: DefaultButton.Config) -> UIView{
        let defaultButton = DefaultButton()
        defaultButton.config = config
        defaultButton.contentHorizontalAlignment = .left
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
        var heightType: TitleDecorator.DecoratedViewHeight = .none
        switch input.viewType {
        case .image:
            heightType = .productCellMinimalHeight
        default:
            heightType = .productCellHeight
        }
        let view = makeView(by: input.viewType)
     
        let decorator = TitleDecorator(
            decoratedView: view,
            heightDecoratedView: .productCellHeight
        )
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

extension ProductContentCell {
    struct Input {
        let firstRow: [ProductViewInput]
        let secondRow: [ProductViewInput]
        let thirdRow: [ProductViewInput]
    }
    
}
