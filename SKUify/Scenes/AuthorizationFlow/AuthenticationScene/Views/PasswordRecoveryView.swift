//
//  PasswordRecoveryView.swift
//  SKUify
//
//  Created by George Churikov on 25.11.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordRecoveryView: ContainerBorderVerticalStack {
    private var disposeBag = DisposeBag()
    
    // MARK: - UI Elements
    
    private let emailTxtField = TitledTextField()
    private let recoverPasswordButton = DefaultButton()
    private let signInClickableLabel = ClickableLabel()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Make binding to views

    fileprivate func makeBinding(_ input: Input) {
        disposeBag = DisposeBag()
        bindToEmailTxtField(input)
        bindToRecoverPasswordButton(input)
        bindToSignInClickableLabel(input)

    }
    
    // MARK: - Private methods

    private func bindToEmailTxtField(_ input: Input) {
        input.emailTxtFieldConfigs
            .drive(emailTxtField.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToRecoverPasswordButton(_ input: Input) {
        input.recoverButtonConfig
            .drive(recoverPasswordButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToSignInClickableLabel(_ input: Input) {
        input.signInClickableLabelConfig
            .drive(signInClickableLabel.rx.config)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup Views
 
    
    private func setupContainerView() {
        spacing = 20.0

        views = [
            emailTxtField,
            recoverPasswordButton,
            signInClickableLabel
        ]
        setCustomSpacing(15, after: emailTxtField)
        setCustomSpacing(19, after: signInClickableLabel)

    }
}

// MARK: - Input

extension PasswordRecoveryView {
    struct Input {
        let emailTxtFieldConfigs: Driver<TitledTextField.Config>
        let recoverButtonConfig: Driver<DefaultButton.Config>
        let signInClickableLabelConfig: Driver<ClickableLabel.Config>
        
        func empty() -> Input {
            .init(
                emailTxtFieldConfigs: .empty(),
                recoverButtonConfig: .empty(),
                signInClickableLabelConfig: .empty()
            )
        }
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: PasswordRecoveryView {
    var input: Binder<PasswordRecoveryView.Input> {
        return Binder(self.base) { view, input in
            view.makeBinding(input)
        }
    }
    
}
