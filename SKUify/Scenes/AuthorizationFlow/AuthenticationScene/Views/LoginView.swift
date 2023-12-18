//
//  LoginView.swift
//  SKUify
//
//  Created by George Churikov on 25.11.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginView: ContainerBorderVerticalStack {
    private var disposeBag = DisposeBag()
    
    // MARK: - UI Elements
    
    private let fieldsContainer = VerticalStack()
    private let buttonsContainer = HorizontalStack()

    private let rememberMeButton = DefaultButton()
    private let forgotPasswordButton = DefaultButton()
    private let logInButton = DefaultButton()
    
    private let createAccountLabel = UILabel()
    private let createAccountButton = DefaultButton()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupButtonsContainer()
        setupCreateAccountLabel()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Make binding to views

    fileprivate func makeBinding(_ input: Input) {
        disposeBag = DisposeBag()
        
        bindToForgotPasswordButton(input)
        bindToRememberMeButton(input)
        bindToLoginButton(input)
        bindToFieldsContainer(input)
        bindToCreateAccountLabel(input)
        bindToCreateAccountButton(input)
    }
    
    // MARK: - Private methods
    
    private func bindToCreateAccountButton(_ input: Input) {
        input.createAccountButtonConfig
            .drive(createAccountButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToCreateAccountLabel(_ input: Input) {
        input.createAccountText
            .drive(createAccountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindToForgotPasswordButton(_ input: Input) {
        input.forgotPasswordButtonConfig
            .drive(forgotPasswordButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToRememberMeButton(_ input: Input) {
        input.rememberMeButtonConfig
            .drive(rememberMeButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToLoginButton(_ input: Input) {
        input.loginButtonConfig
            .drive(logInButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToFieldsContainer(_ input: Input) {
        fieldsContainer.spacing = 10.0

        input.loginTxtFieldConfigs
            .map { items in
                items.map({ $0.createFromInput() })
            }
            .drive(fieldsContainer.rx.views)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup Views
    
    private func setupCreateAccountLabel() {
        createAccountLabel.font = .manrope(
            type: .semiBold,
            size: 16
        )
        createAccountLabel.textAlignment = .center
        createAccountLabel.textColor = .textColor
    }
    
    private func setupButtonsContainer() {
        buttonsContainer.distribution = .equalSpacing
        buttonsContainer.views = [
            rememberMeButton,
            forgotPasswordButton
        ]
    }
    
    private func setupContainerView() {
        spacing = 20.0
        
        views = [
            fieldsContainer,
            buttonsContainer,
            logInButton,
            createAccountLabel,
            createAccountButton
        ]
        
        setCustomSpacing(0, after: fieldsContainer)
        setCustomSpacing(0, after: createAccountLabel)

    }
}

// MARK: - Input

extension LoginView {
    struct Input {
        let loginTxtFieldConfigs: Driver<[TitledTextField.Config]>
        let loginButtonConfig: Driver<DefaultButton.Config>
        let rememberMeButtonConfig: Driver<DefaultButton.Config>
        let forgotPasswordButtonConfig: Driver<DefaultButton.Config>
        let createAccountText: Driver<String>
        let createAccountButtonConfig: Driver<DefaultButton.Config>
        
        func empty() -> Input {
            .init(
                loginTxtFieldConfigs: .empty(),
                loginButtonConfig: .empty(),
                rememberMeButtonConfig: .empty(),
                forgotPasswordButtonConfig: .empty(),
                createAccountText: .empty(),
                createAccountButtonConfig: .empty()
            )
        }
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: LoginView {
    var input: Binder<LoginView.Input> {
        return Binder(self.base) { view, input in
            view.makeBinding(input)
        }
    }
    
}
