//
//  SalesSetupView.swift
//  SKUify
//
//  Created by George Churikov on 02.02.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SalesSetupView: UIView {
    fileprivate var disposeBag = DisposeBag()

    // MARK: - UI elements

    private lazy var orderButton = DefaultButton()
    private lazy var refundsButton = DefaultButton()
    private lazy var searchTextField = DefaultTextField()
    
    private lazy var filterByDatePopoverButton = DefaultButton()
    private lazy var filterByMarketplacePopoverButton = DefaultButton()

    private lazy var titledSwitchView = TitledSwitchView()
    private lazy var titledSwitchContetnView = UIView()

    private lazy var buttonStack = HorizontalStack()
    private lazy var topContentStack = HorizontalStack()
    private lazy var popoverButtonsStack = HorizontalStack()
    private lazy var contentStack = VerticalStack()

    private let spacing: CGFloat = 5.0
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonStack()
        setupTopContentStack()
        setupPopoverButtonsStack()
        setupTitledSwitchViewContentView()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup data
    
    func setupInput(_ input: Input) {
        bindToOrderButton(input)
        bindToRefundsButton(input)
        setupSearchTextField(input)
        setupFilterByDatePopoverButton(input)
        setupfilterByMarketplacePopoverButton(input)
        setupTitledSwitchView(input)
    }
    
    private func bindToOrderButton(_ input: Input) {
        input.orderButtonConfig
            .drive(orderButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToRefundsButton(_ input: Input) {
        input.refundsButtonConfig
            .drive(refundsButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func setupSearchTextField(_ input: Input) {
        searchTextField.config = input.searchTextFieldConfig
    }
    
    private func setupFilterByDatePopoverButton(_ input: Input) {
        filterByDatePopoverButton.config = input.filterByDatePopoverButtonConfig
    }
    
    private func setupfilterByMarketplacePopoverButton(_ input: Input) {
        filterByMarketplacePopoverButton.config = input.filterByMarketplacePopoverButtonConfig
    }
    
    private func setupTitledSwitchView(_ input: Input) {
        titledSwitchView.setupInput(input.COGsInput)
    }
    
    //MARK: - Setup views

    private func setupTitledSwitchViewContentView() {
        titledSwitchContetnView.layer.borderWidth = 2.0
        titledSwitchContetnView.layer.cornerRadius = 12.0
        titledSwitchContetnView.layer.borderColor = UIColor.border.cgColor
        titledSwitchContetnView.backgroundColor = .white
        
        titledSwitchContetnView.addSubview(titledSwitchView)

        titledSwitchView.snp.makeConstraints { make in
            make.verticalEdges
                .equalToSuperview()
                .inset(5)
            make.horizontalEdges
                .equalToSuperview()
                .inset(10)
        }
       
    }
    
    private func setupButtonStack() {
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = spacing
        buttonStack.views = [
            orderButton,
            refundsButton
        ]
    }
    
    private func setupTopContentStack() {
        topContentStack.distribution = .fillEqually
        topContentStack.spacing = spacing
        topContentStack.views = [
            buttonStack,
            searchTextField
        ]
    }
    
    private func setupPopoverButtonsStack() {
        popoverButtonsStack.distribution = .fillEqually
        popoverButtonsStack.spacing = spacing
        popoverButtonsStack.views = [
            filterByDatePopoverButton,
            filterByMarketplacePopoverButton
        ]
    }
    
    private func setupContentStack() {
        contentStack.distribution = .fill
        contentStack.spacing = spacing
        contentStack.views = [
            topContentStack,
            popoverButtonsStack,
            titledSwitchContetnView
        ]
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

//MARK: - Input

extension SalesSetupView {
    struct Input {
        var orderButtonConfig: Driver<DefaultButton.Config>
        var refundsButtonConfig: Driver<DefaultButton.Config>
        let filterByDatePopoverButtonConfig: DefaultButton.Config
        let filterByMarketplacePopoverButtonConfig: DefaultButton.Config
        let searchTextFieldConfig: DefaultTextField.Config
        let COGsInput: TitledSwitchView.Input
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: SalesSetupView {
    var input: Binder<SalesSetupView.Input> {
        return Binder(self.base) { view, input in
            view.disposeBag = DisposeBag()
            view.setupInput(input)
        }
    }
    
}

