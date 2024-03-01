//
//  PasswordRecoveryResultView.swift
//  SKUify
//
//  Created by George Churikov on 25.11.2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class PasswordRecoveryResultView: ContainerBorderVerticalStack {
    fileprivate var disposeBag = DisposeBag()
    
    // MARK: - UI Elements

    private let mailImage = UIImageView()
    private let toSignInButton = DefaultButton()
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContainerView()
        setupMailImage()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Make binding to views

    fileprivate func setupInput(_ input: Input) {
        bindToSignInButton(input)
    }
    
    // MARK: - Private methods

    private func bindToSignInButton(_ input: Input) {
        input.signInButtonConfig
            .drive(toSignInButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func setupMailImage() {
        mailImage.image = .mail
        mailImage.contentMode = .scaleAspectFit
    }
    
    private func setupContainerView() {
        spacing = 30.0

        views = [
            mailImage,
            toSignInButton
        ]
    }
    
}

extension PasswordRecoveryResultView {
    struct Input {
        var signInButtonConfig: Driver<DefaultButton.Config>
    }
}

// MARK: - Custom binding

extension Reactive where Base: PasswordRecoveryResultView {
    var input: Binder<PasswordRecoveryResultView.Input> {
        return Binder(self.base) { view, input in
            view.disposeBag = DisposeBag()
            view.setupInput(input)
        }
    }
    
}

