//
//  SignUpView.swift
//  SKUify
//
//  Created by George Churikov on 27.11.2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SignUpView: ContainerBorderVerticalStack {
    fileprivate var disposeBag = DisposeBag()
    
    // MARK: - UI Elements

    private let fieldsContainer = VerticalStack()
    
    private let buttonsContainer = HorizontalStack()
    private let agreeButton = DefaultButton()
    private let termConditionsButton = DefaultButton()
    
    private let signUpButton = DefaultButton()
    
    private let signInClickableLabel = ClickableLabel()

    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupButtonsContainer()
    
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Make binding to views

    fileprivate func setupInput(_ input: Input) {
        bindToFieldsContainer(input)
        bindToAgreeButton(input)
        bindToTermConditionsButton(input)
        bindToSignUpButtonConfig(input)
        bindToSignInClickableLabelConfig(input)
        
        // always afrter binding
        setupTermConditionsButton()
    }
    
    private func bindToFieldsContainer(_ input: Input) {
        fieldsContainer.spacing = 10.0

        input.signUpTxtFieldConfigs
            .map { items in
                items.map({ $0.createFromInput() })
            }
            .drive(fieldsContainer.rx.views)
            .disposed(by: disposeBag)
    }
    
    private func bindToAgreeButton(_ input: Input) {
        input.agreeButtonConfig
            .drive(agreeButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToTermConditionsButton(_ input: Input) {
        input.termConditionsButtonConfig
            .drive(termConditionsButton.rx.config)
            .disposed(by: disposeBag)
        
    }
    
    private func bindToSignUpButtonConfig(_ input: Input) {
        input.signUpButtonConfig
            .drive(signUpButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToSignInClickableLabelConfig(_ input: Input) {
        input.signInClickableLabelConfig
            .drive(signInClickableLabel.rx.config)
            .disposed(by: disposeBag)

    }
    
    // MARK: - Private methods
    
    private func setupTermConditionsButton() {
        termConditionsButton.configuration?.contentInsets = .zero
    }
    
    private func setupButtonsContainer() {
        buttonsContainer.spacing = 2
        
        buttonsContainer.views = [
            agreeButton,
            termConditionsButton,
            UIView.spacer()
        ]
    }
    
    private func setupContainerView() {
        spacing = 15.0
        layoutMargins.bottom = 29.0

        views = [
            fieldsContainer,
            buttonsContainer,
            signUpButton,
            signInClickableLabel
        ]
        
        
    }
    
}

extension SignUpView {
    struct Input {
        var signUpTxtFieldConfigs: Driver<[TitledTextField.Config]>
        var agreeButtonConfig: Driver<DefaultButton.Config>
        var termConditionsButtonConfig: Driver<DefaultButton.Config>
        var signUpButtonConfig: Driver<DefaultButton.Config>
        var signInClickableLabelConfig: Driver<ClickableLabel.Config>
    }
}

// MARK: - Custom binding

extension Reactive where Base: SignUpView {
    var input: Binder<SignUpView.Input> {
        return Binder(self.base) { view, input in
            view.disposeBag = DisposeBag()
            view.setupInput(input)
        }
    }
    
}

