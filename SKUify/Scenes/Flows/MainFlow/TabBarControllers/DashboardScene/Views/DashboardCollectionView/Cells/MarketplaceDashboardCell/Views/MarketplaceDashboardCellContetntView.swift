//
//  MarketplaceDashboardCellContetntView.swift
//  SKUify
//
//  Created by George Churikov on 11.12.2023.
//

import Foundation
import UIKit
import SnapKit

protocol MarketplaceDashboardCellContentViewProtocol {
    associatedtype Input
    func setupInput(_ input: Input)
}

final class MarketplaceDashboardCellContentView: UIView {
    
    // MARK: UIElements
    
    // Labels
    private let salesLabel = UILabel()
    private let profitLabel = UILabel()
    private let refundsLabel = UILabel()
    private let unitLabel = UILabel()
    private let roiLabel = UILabel()
    private let marginLabel = UILabel()

    // Decorators
    private lazy var salesLabelDecorator = TitleDecorator(decoratedView: salesLabel)
    private lazy var profitLabelDecorator = TitleDecorator(decoratedView: profitLabel)
    private lazy var refundsLabelDecorator = TitleDecorator(decoratedView: refundsLabel)
    private lazy var unitLabelDecorator = TitleDecorator(decoratedView: unitLabel)
    private lazy var roiLabelDecorator = TitleDecorator(decoratedView: roiLabel)
    private lazy var marginLabelDecorator = TitleDecorator(decoratedView: marginLabel)
    
    // Containers
    private let contentStack = HorizontalStack()
    private let firstRowStack = VerticalStack()
    private let secondRowStack = VerticalStack()
    private let thirdRowStack = VerticalStack()

    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStacks()
        setupLabels()
        setupContentStack()
        setupFristRowStack()
        setupSecondRowStack()
        setupThirdRowStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Setup views

    private func setupSecondRowStack() {
        secondRowStack.views = [
            profitLabelDecorator,
            roiLabelDecorator,
        ]
    }

    private func setupFristRowStack() {
        firstRowStack.views = [
            salesLabelDecorator,
            unitLabelDecorator
        ]
    }
    
    private func setupThirdRowStack() {
        thirdRowStack.views = [
            marginLabelDecorator,
            refundsLabelDecorator
        ]
    }
    
    private func setupContentStack() {
        contentStack.views = [
            firstRowStack,
            secondRowStack,
            thirdRowStack
        ]
        contentStack.distribution = .equalSpacing
        
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.directionalHorizontalEdges
                .equalToSuperview()
                .inset(10)
            make.top
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
                .inset(10)
        }
    }
    
    private func setupStacks() {
        [
            firstRowStack,
            secondRowStack,
            thirdRowStack
        ]
            .forEach { stack in
                stack.distribution = .fillProportionally
            }
    }
    
    private func setupLabels() {
        [
            salesLabel,
            profitLabel,
            refundsLabel,
            unitLabel,
            roiLabel,
            marginLabel
        ]
            .forEach { label in
                label.textColor = .textColor
                label.font = .manrope(
                    type: .bold,
                    size: 15
                )
            }
    }
    
}

// MARK: Input

extension MarketplaceDashboardCellContentView {
    struct Input {
        let sales: KeyValue
        let profit: KeyValue
        let refunds: KeyValue
        let unit: KeyValue
        let roi: KeyValue
        let margin: KeyValue
    }
    
    struct KeyValue {
        let title: String
        let value: String
    }
}

// MARK: Set data to view

extension MarketplaceDashboardCellContentView: MarketplaceDashboardCellContentViewProtocol {
    func setupInput(_ input: Input) {
        setupSalesData(input)
        setupProfitData(input)
        setupRefundsData(input)
        setupUnitData(input)
        setupRoiData(input)
        setupMarginData(input)
    }
    
    private func setupSalesData(_ input: Input) {
        salesLabel.text = input.sales.value
        salesLabelDecorator.decorate(title: input.sales.title)
    }
    
    private func setupProfitData(_ input: Input) {
        profitLabel.text = input.profit.value
        profitLabelDecorator.decorate(title: input.profit.title)
    }
    
    private func setupRefundsData(_ input: Input) {
        refundsLabel.text = input.refunds.value
        refundsLabelDecorator.decorate(title: input.refunds.title)
    }
    
    private func setupUnitData(_ input: Input) {
        unitLabel.text = input.unit.value
        unitLabelDecorator.decorate(title: input.unit.title)
    }
    
    private func setupRoiData(_ input: Input) {
        roiLabel.text = input.roi.value
        roiLabelDecorator.decorate(title: input.roi.title)
    }
    
    private func setupMarginData(_ input: Input) {
        marginLabel.text = input.margin.value
        marginLabelDecorator.decorate(title: input.margin.title)
    }
    
}
