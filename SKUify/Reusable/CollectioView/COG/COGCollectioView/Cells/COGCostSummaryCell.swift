//
//  COGCostSummaryCell.swift
//  SKUify
//
//  Created by George Churikov on 05.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class COGCostSummaryCell: UICollectionViewCell {
    
    // MARK: - UI elements

    private lazy var contentStack = VerticalStack()
    
    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    // MARK: Setup views
    
    private func setupCell() {
        backgroundColor = .cellColor
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    private func setupContentStack() {
        contentStack.spacing = 10.0
        
        contentView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(20.0)
        }
    }
    
    // MARK: Factory methods
    
    private func makeView(_ type: COGCostSummaryViewType) -> UIView {
        switch type {
        case .label(let text):
            return makeLabel(text)
        case .buttons(let configs):
            return makeButtonsStack(configs) 
        case .none:
            return UIView()
        }
    }

    private func makeButtonsStack(_ configs: [DefaultButton.Config]) -> UIView {
        let hStack = HorizontalStack()
        hStack.views = configs.map { $0.toButton() }
        hStack.spacing = 10.0
        return hStack
    }
    
    private func makeLabel(_ text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .manrope(
            type: .extraBold,
            size: 20
        )
        label.textAlignment = .center
        label.textColor = .textColor
        return label
    }

}

// MARK: Input

extension COGCostSummaryCell {
    struct Input {
        let content: [COGCostSummaryViewType]
    }
    
}
