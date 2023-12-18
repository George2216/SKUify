//
//  DefaultSettingsButton.swift
//  SKUify
//
//  Created by George Churikov on 01.12.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DefaultSettingsButton: UIButton {
    fileprivate var disposeBag = DisposeBag()

    private var configStorage = Config.empty()
    
    var config: Config {
        get { configStorage }
        set {
            configStorage = newValue
            setupConfig(config: newValue)
        }
    }
    
    private let customTitleLabel = UILabel()
    private let customImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupCustomTitleLabel()
        setupCustomImageView()
        customTitleLabelToSubview()
        customImageViewToSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfig(config: Config) {
        customTitleLabel.text = config.title
        if let action = config.action {
            rx.tap.subscribe(onNext: {
                action()
            }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Add to subview

    private func customImageViewToSubview() {
        addSubview(customImageView)
        customImageView.snp.makeConstraints { make in
            make.trailing
                .equalToSuperview()
                .inset(21)
            make.centerY
                .equalToSuperview()
        }
    }
    
    private func customTitleLabelToSubview() {
        addSubview(customTitleLabel)
        customTitleLabel.snp.makeConstraints { make in
            make.leading
                .equalToSuperview()
                .inset(15)
            make.centerY
                .equalToSuperview()
        }
    }
    
    // MARK: - Setup views

    private func setupView() {
        layer.borderWidth = 2.0
        layer.cornerRadius = 12.0
        layer.borderColor = UIColor.border.cgColor
        backgroundColor = .white
        
        snp.makeConstraints { make in
            make.height
                .equalTo(50)
        }
    }
    
    private func setupCustomTitleLabel() {
        customTitleLabel.textColor = .textColor
        customTitleLabel.font = .manrope(
            type: .bold,
            size: 15
        )
    }
    
    private func setupCustomImageView() {
        let imageConfig = UIImage.SymbolConfiguration(
            font: .manrope(
                type: .bold,
                size: 16
            )
        )
        customImageView.image = .next.withConfiguration(imageConfig)
                
    }
}

// MARK: - Configuration

extension DefaultSettingsButton {
    
    struct Config {
        let title: String
        let action: (() -> Void)?
        
        static func empty() -> Config {
            .init(
                title: "",
                action: nil
            )
        }
        
        func toButton() -> DefaultSettingsButton {
            let button = DefaultSettingsButton()
            button.config = self
            return button
        }
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: DefaultSettingsButton {
    var config: Binder<DefaultSettingsButton.Config> {
        return Binder(self.base) { button, config in
            button.disposeBag = DisposeBag()
            button.config = config
        }
    }
}
