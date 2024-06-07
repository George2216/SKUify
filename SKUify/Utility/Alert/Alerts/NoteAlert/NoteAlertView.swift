//
//  NoteAlertView.swift
//  SKUify
//
//  Created by George Churikov on 26.03.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class NoteAlertView: UIView {
    private let disposeBag = DisposeBag()

    weak var delegate: BaseAlertProtocol?

    // MARK: - UI elements

    private lazy var contentDecorator = TitleDecorator(
        decoratedView: contentStack,
        font: .manrope(
            type: .bold,
            size: 15
        ),
        textColor: .textColor,
        spacing: 5.0
    )
    
    private lazy var textView = UITextView()
    
    // Containers
    private lazy var buttonsStack = HorizontalStack()
    private lazy var contentStack = VerticalStack()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cellColor
        setupTextView()
        setupButtonsStack()
        setupContentStack()
        setupTitleDecorator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        textView.layer.borderColor = UIColor.border.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 10
    }
    
    func setupInput(_ input: Input) {
        contentDecorator.decorate(title: input.title)
        textView.text = input.content
        buttonsStack.views = makeButtons(input.buttonsConfigs)
        textView.rx.text.compactMap { $0 }
            .bind(to: input.subscriber)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func makeButtons(_ configs: [DefaultButton.Config]) -> [DefaultButton] {
        configs.map { config in
            var config = config
            switch config.action {
            case .simple(let action):
                config.action = .simple({ [weak self] in
                    guard let self else { return }
                    self.delegate?.hideAlert()
                    action?()
                })
            default: 
                break
            }
            
            return config.toButton()
        }
    }
    
    // MARK: - Setup views
    
    private func setupTextView() {
        textView.font = .manrope(
            type: .semiBold,
            size: 15
        )
        textView.textColor = .textColor

        textView.snp.makeConstraints { make in
            make.height
                .equalTo(100)
        }
    }
    
    private func setupButtonsStack() {
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 25
    }
    
    private func setupContentStack() {
        contentStack.views = [
            textView,
            buttonsStack
        ]
        
        contentStack.spacing = 15
    }
    
    private func setupTitleDecorator() {
        addSubview(contentDecorator)
        contentDecorator.snp.makeConstraints { make in
            make.horizontalEdges
                .equalToSuperview()
                .inset(15)
            make.top
                .equalToSuperview()
                .inset(10)
            make.bottom
                .equalToSuperview()
                .inset(15)
        }
    }

}

// MARK: - Input

extension NoteAlertView {
    struct Input {
        let title: String
        let content: String
        let subscriber: BehaviorSubject<String>
        let buttonsConfigs: [DefaultButton.Config]
    }
    
}
