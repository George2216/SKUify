//
//  InventorySwitchesView.swift
//  SKUify
//
//  Created by George Churikov on 13.03.2024.
//

import UIKit
import SnapKit

final class InventorySwitchesView: UIView {
    
    // MARK: - UI elements
    
    private lazy var inactiveTitledSwitch = TitledSwitchView()
    private lazy var noCOGsTiledSwitch = TitledSwitchView()
    private lazy var warningsTitledSwitch = TitledSwitchView()
    
    // Containers
    private lazy var bottonSwitchesContainerStack = HorizontalStack()
    private lazy var contentStack = VerticalStack()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupBottonSwitchesContainerStack()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set data
    
    func setupInput(_ input: Input) {
        setupInactiveTitledSwitch(input)
        setupNoCOGsTiledSwitch(input)
        setupWarningsTitledSwitch(input)
    }
    
    private func setupInactiveTitledSwitch(_ input: Input) {
        inactiveTitledSwitch.setupInput(input.inactiveTitledSwitchInput)
    }
    private func setupNoCOGsTiledSwitch(_ input: Input) {
        noCOGsTiledSwitch.setupInput(input.noCOGsTiledSwitchInput)
    }
    
    private func setupWarningsTitledSwitch(_ input: Input) {
        warningsTitledSwitch.setupInput(input.warningsTitledSwitchInput)
    }
    
    // MARK: - Setup views
    
    private func setupView() {
        layer.borderWidth = 2.0
        layer.cornerRadius = 12.0
        layer.borderColor = UIColor.border.cgColor
        backgroundColor = .white
    }
    
    private func setupBottonSwitchesContainerStack() {
        bottonSwitchesContainerStack.views = [
            warningsTitledSwitch,
            noCOGsTiledSwitch
        ]
        
        bottonSwitchesContainerStack.alignment = .center
        bottonSwitchesContainerStack.distribution = .fillProportionally
        bottonSwitchesContainerStack.spacing = 10
        
    }
    
    private func setupContentStack() {
        contentStack.views = [
            inactiveTitledSwitch,
            bottonSwitchesContainerStack
        ]
        
        contentStack.setPagging(10)

        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

// MARK: - Input

extension InventorySwitchesView {
    struct Input {
        let inactiveTitledSwitchInput: TitledSwitchView.Input
        let noCOGsTiledSwitchInput: TitledSwitchView.Input
        let warningsTitledSwitchInput: TitledSwitchView.Input
    }
    
}
