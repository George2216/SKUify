//
//  ProfileContentView.swift
//  SKUify
//
//  Created by George Churikov on 19.01.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileContentView: UIView {
    fileprivate var disposeBag = DisposeBag()

    // MARK: - UI elements
    
    private lazy var profileHeaderView = ProfileHeaderView()
    private lazy var saveButton = DefaultButton()
    
    private lazy var fieldsStack = VerticalStack()
    private lazy var contentStack = VerticalStack()
    private lazy var saveButtonStack = HorizontalStack()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentStack()
        setupFieldsStack()
        setupSaveButtonStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup input

    func setupInput(_ input: Input) {
        setupProfileHeaderView(input)
        setupFieldsStack(input)
        bindToSaveButton(input)
    }

    private func setupProfileHeaderView(_ input: Input) {
        profileHeaderView.setupInput(input.profileHeaderViewInput)
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
    
    private func setupSaveButtonStack() {
        saveButtonStack.views = [
            saveButton,
            UIView.spacer()
        ]
    }
    
    private func setupContentStack() {
        contentStack.views = [
            profileHeaderView,
            fieldsStack,
            saveButtonStack
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

extension ProfileContentView {
    struct Input {
        let profileHeaderViewInput: ProfileHeaderView.Input
        let fieldsConfigs: [TitledTextField.Config]
        let saveButtonConfig: Driver<DefaultButton.Config>
    }
    
}


// MARK: - Custom binding

extension Reactive where Base: ProfileContentView {
    var input: Binder<ProfileContentView.Input> {
        return Binder(self.base) { view, input in
            view.disposeBag = DisposeBag()
            view.setupInput(input)
        }
    }
    
}
