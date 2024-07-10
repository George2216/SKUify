//
//  InventorySetupView.swift
//  SKUify
//
//  Created by George Churikov on 13.03.2024.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class InventorySetupView: UIView {
    fileprivate var disposeBag = DisposeBag()

    // MARK: - UI elements
    
    private lazy var ordersButton = DefaultButton()
    private lazy var buyBotImportsButton = DefaultButton()
    
    private lazy var searchTextFiest = DefaultTextField()
    
    private lazy var switchesView = InventorySwitchesView()
    
    // Containers
    private lazy var buttonStack = HorizontalStack()
    private lazy var contentStack = VerticalStack()
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonsStack()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set data

    func setupInput(_ input: Input) {
        setupOrdersButton(input)
        setupBuyBotImportsButton(input)
        setupSearchTextFiest(input)
        setupSwitchesView(input)
    }
    
    private func setupOrdersButton(_ input: Input) {
        input.ordersButtonConfid
            .drive(ordersButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func setupBuyBotImportsButton(_ input: Input) {
        input.buyBotImportsButtonConfid
            .drive(buyBotImportsButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func setupSearchTextFiest(_ input: Input) {
        input.searchTextFiestConfig
            .drive(searchTextFiest.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func setupSwitchesView(_ input: Input) {
        switchesView.setupInput(input.switchesViewInput)
    }
    
    // MARK: - Setup views
    
    private func setupButtonsStack() {
        buttonStack.views = [
            ordersButton,
            buyBotImportsButton
        ]
        buttonStack.snp.makeConstraints { make in
            make.height
                .equalTo(34)
        }
        
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
    }
    
    private func setupContentStack() {
        contentStack.views = [
            buttonStack,
            searchTextFiest,
            switchesView
        ]
        contentStack.spacing = 10
        
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }

}

// MARK: - Input

extension InventorySetupView {
    struct Input {
        let ordersButtonConfid: Driver<DefaultButton.Config>
        let buyBotImportsButtonConfid: Driver<DefaultButton.Config>
        let searchTextFiestConfig: Driver<DefaultTextField.Config>
        let switchesViewInput: InventorySwitchesView.Input
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: InventorySetupView {
    var input: Binder<InventorySetupView.Input> {
        return Binder(self.base) { view, input in
            view.disposeBag = DisposeBag()
            view.setupInput(input)
        }
    }
    
}

