//
//  PopoverButton.swift
//  SKUify
//
//  Created by George Churikov on 30.11.2023.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit

final class PopoverButton: UIView {
    fileprivate var disposeBag = DisposeBag()
    
    private var configStorage = Config.empty()
    
    var config: Config {
        get { configStorage }
        set {
            configStorage = newValue
            setupConfig(config: newValue)
        }
    }
    
    // MARK: - UI element

    private let titleLabel = UILabel()
    private let chevronImageView = UIImageView()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTitleLabel()
        setupChevronImageView()
        titleLabelToSubview()
        chevronImageViewToSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConfig(config: Config) {
        titleLabel.text = config.title
        
        if let action = config.action {
            let tapGesture = UITapGestureRecognizer()
            addGestureRecognizer(tapGesture)
            
            tapGesture.rx
                .event
                .subscribe(onNext: { [weak self] _ in
                    guard let self else { return }
                    action(self.centerOfView())
                })
                .disposed(by: disposeBag)
        }
        
    }
    
    // MARK: - Setup views
    
    private func setupView() {
        layer.borderWidth = 2.0
        layer.cornerRadius = 12.0
        layer.borderColor = UIColor.border.cgColor
        backgroundColor = .white
        isUserInteractionEnabled = true
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Filter marketplace"
        titleLabel.font = .manrope(type: .medium, size: 13)
        titleLabel.textColor = .lightSubtextColor
    }
    
    private func setupChevronImageView() {
        chevronImageView.image = UIImage(
            systemName: "chevron.down",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 16,
                weight: .bold
            )
        )
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.tintColor = .primary
    }
    
    // MARK: - Add to subview

    private func titleLabelToSubview() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading
                .equalToSuperview()
                .inset(10)
            make.centerY
                .equalToSuperview()
        }
    }
    
    private func chevronImageViewToSubview() {
        addSubview(chevronImageView)
        chevronImageView.snp.makeConstraints { make in
            make.trailing
                .equalToSuperview()
                .inset(10)
            make.size
                .equalTo(16)
            make.centerY
                .equalToSuperview()
        }
    }
    
}

// MARK: - Configuration

extension PopoverButton {
    
    struct Config {
        let title: String
        let action: ((CGPoint) -> Void)?
        
        static func empty() -> Config {
            .init(
                title: "",
                action: nil
            )
        }
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: PopoverButton {
    var config: Binder<PopoverButton.Config> {
        return Binder(self.base) { button, config in
            button.disposeBag = DisposeBag()
            button.config = config
        }
    }
}
