//
//  SecurityContentView.swift
//  SKUify
//
//  Created by George Churikov on 05.06.2024.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SecurityContentView: UIView {
    private var disposeBag = DisposeBag()

    // MARK: UI elements
    
    private lazy var saveButton = DefaultButton()
    
    private lazy var fieldsStack = VerticalStack()
    private lazy var contentStack = VerticalStack()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFieldsStack()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup input

    func setupInput(_ input: Input) {
        disposeBag = DisposeBag()
        setupFieldsStack(input)
        bindToSaveButton(input)
    }

    private func setupFieldsStack(_ input: Input) {
        fieldsStack.views = input.fieldsConfig
            .map { $0.createFromInput() }
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
            fieldsStack,
            saveButton
        ]
        contentStack.spacing = 20
        
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

extension SecurityContentView {
    struct Input {
        let fieldsConfig: [TitledTextField.Config]
        let saveButtonConfig: Driver<DefaultButton.Config>
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: SecurityContentView {
    var input: Binder<SecurityContentView.Input> {
        return Binder(self.base) { view, input in
            view.setupInput(input)
        }
    }
    
}
