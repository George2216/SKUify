//
//  COGApplyToUnsoldInventoryCell.swift
//  SKUify
//
//  Created by George Churikov on 03.05.2024.
//

import Foundation
import UIKit
import SnapKit

final class COGApplyToInventoryCell: UICollectionViewCell {

    // MARK: UI elements
    
    private lazy var titledSwitch = TitledSwitchView()
    
    private lazy var contentStack = VerticalStack()
    
    private let spacing: CGFloat = 10.0
  
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup views
    
    func setupInput(_ input: Input) {
        titledSwitch.setupInput(input.titledSwitchInput)
        
        contentStack.views = [
            titledSwitch,
            makeButtonsStack(input.buttonConfigs)
        ]
    }
    
    func setupWigth(_ width: CGFloat) {
        contentView.snp.makeConstraints { make in
            make.width
                .equalTo(width)
        }
    }
    
    // MARK: Private methods

    private func makeButtonsStack(_ configs: [DefaultButton.Config]) -> UIView {
        let hStack = HorizontalStack()
        hStack.views = configs.map { $0.toButton() }
        hStack.spacing = 10.0
        return hStack
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
    
    private func setupCell() {
        backgroundColor = .cellColor
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
}

// MARK: - Input

extension COGApplyToInventoryCell {
    struct Input {
        let titledSwitchInput: TitledSwitchView.Input
        let buttonConfigs: [DefaultButton.Config]
    }
    
}
