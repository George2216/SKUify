//
//  CommonAlertView.swift
//  SKUify
//
//  Created by George Churikov on 26.03.2024.
//

import UIKit

final class CommonAlertView: UIView {
    
    weak var delegate: BaseAlertProtocol?
    
    // MARK: - UI elements
    
    private lazy var titleLabel = UILabel()
    private lazy var messageLabel = UILabel()
    
    // Containers
    private lazy var labelsStack = VerticalStack()
    private lazy var buttonsStack = HorizontalStack()
    private lazy var contentStack = VerticalStack()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupTitleLabel()
        setupMessageLabel()
        setupLabelsStack()
        setupButtonsStack()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    func setupInput(_ input: Input) {
        titleLabel.text = input.title
        messageLabel.text = input.message
        buttonsStack.views = makeButtons(input.buttonsConfigs)
    }
    
    // MARK: - Private methods
    
    private func makeButtons(_ configs: [DefaultButton.Config]) -> [DefaultButton] {
        configs.map { config in
            let action = config.action
            var config = config
            config.action = { [weak self] in
                guard let self else { return }
                self.delegate?.hideAlert()
                action?()
            }
            return config.toButton()
        }
    }
    
    // MARK: - Setup views

    private func setupTitleLabel() {
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.font = .manrope(
            type: .extraBold,
            size: 20
        )
    }
    
    private func setupMessageLabel() {
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .manrope(
            type: .semiBold,
            size: 15
        )
    }
    
    private func setupLabelsStack() {
        labelsStack.views = [
            titleLabel,
            messageLabel
        ]
        
        labelsStack.spacing = 5
    }
    
    private func setupButtonsStack() {
        buttonsStack.distribution = .fill
        buttonsStack.spacing = 10
    }
    
    private func setupContentStack() {
        contentStack.views = [
            labelsStack,
            buttonsStack
        ]
        
        contentStack.spacing = 20
        
        addSubview(contentStack)
        
        contentStack.snp.makeConstraints { make in
            make.horizontalEdges
                .equalToSuperview()
                .inset(15)
            make.verticalEdges
                .equalToSuperview()
                .inset(20)
        }
    }
    
}

// MARK: - Input

extension CommonAlertView {
    struct Input {
        let title: String
        let message: String
        let buttonsConfigs: [DefaultButton.Config]
    }
    
}
