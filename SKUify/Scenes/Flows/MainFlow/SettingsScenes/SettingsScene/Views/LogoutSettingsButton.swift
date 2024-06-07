//
//  LogoutSettingsButton.swift
//  SKUify
//
//  Created by George Churikov on 01.12.2023.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LogoutSettingsButton: UIButton {
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
        setupCustomImageView()
        setupCustomTitleLabel()
        customImageViewToSubview()
        customTitleLabelToSubview()
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
            make.leading
                .equalToSuperview()
                .inset(20)
            make.centerY
                .equalToSuperview()
        }
    }
    
    private func customTitleLabelToSubview() {
        addSubview(customTitleLabel)
        customTitleLabel.snp.makeConstraints { make in
            make.leading
                .equalTo(customImageView.snp.trailing)
                .offset(12)
            make.centerY
                .equalToSuperview()
        }
    }
    
    // MARK: - Setup views

    private func setupView() {
        layer.borderWidth = 1.0
        layer.cornerRadius = 12.0
        layer.borderColor = UIColor.primary.cgColor
        backgroundColor = .field
        
        snp.makeConstraints { make in
            make.height
                .equalTo(50)
        }
    }
    
    private func setupCustomTitleLabel() {
        customTitleLabel.textColor = .primary
        customTitleLabel.font = .manrope(
            type: .bold,
            size: 14
        )
    }
    
    private func setupCustomImageView() {
        let imageConfig = UIImage.SymbolConfiguration(
            font: .manrope(
                type: .bold,
                size: 16
            )
        )
        customImageView.image = .logout.withConfiguration(imageConfig)
                
    }
}

// MARK: - Configuration

extension LogoutSettingsButton {
    
    struct Config {
        let title: String
        let action: (() -> Void)?
        
        static func empty() -> Config {
            .init(
                title: "",
                action: nil
            )
        }
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: LogoutSettingsButton {
    var config: Binder<LogoutSettingsButton.Config> {
        return Binder(self.base) { button, config in
            button.disposeBag = DisposeBag()
            button.config = config
        }
    }
}
