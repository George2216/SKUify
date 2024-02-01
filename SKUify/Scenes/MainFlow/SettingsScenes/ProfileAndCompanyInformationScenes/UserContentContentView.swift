//
//  ProfileContentView.swift
//  SKUify
//
//  Created by George Churikov on 19.01.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class UserContentContentView: UIView {
    fileprivate var disposeBag = DisposeBag()

    // MARK: - UI elements
    
    private lazy var userConentHeaderView = ImageControlView()
    private lazy var saveButton = DefaultButton()
    
    private lazy var fieldsStack = VerticalStack()
    private lazy var contentStack = VerticalStack()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentStack()
        setupFieldsStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup input

    func setupInput(_ input: Input) {
        setupUserContentHeaderView(input)
        setupFieldsStack(input)
        bindToSaveButton(input)
    }

    private func setupUserContentHeaderView(_ input: Input) {
        userConentHeaderView.setupInput(input.profileHeaderViewInput)
    }
    
    private func setupFieldsStack(_ input: Input) {
        fieldsStack.views = input.fieldsConfigs.map { config in
            config.createFromInput()
        }
    }
    
    private func bindToSaveButton(_ input: Input) {
        input.saveButtonConfig
            .drive(saveButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup views

    private func setupFieldsStack() {
        fieldsStack.spacing = 10
    }

    private func setupContentStack() {
        contentStack.views = [
            userConentHeaderView,
            fieldsStack,
            saveButton,
            UIView.spacer()
        ]
        contentStack.spacing = 20
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

// MARK: - Input

extension UserContentContentView {
    struct Input {
        var profileHeaderViewInput: ImageControlView.Input
        let fieldsConfigs: [TitledTextField.Config]
        let saveButtonConfig: Driver<DefaultButton.Config>
    }
    
}


// MARK: - Custom binding

extension Reactive where Base: UserContentContentView {
    var input: Binder<UserContentContentView.Input> {
        return Binder(self.base) { view, input in
            view.disposeBag = DisposeBag()
            view.setupInput(input)
        }
    }
    
}
