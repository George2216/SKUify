//
//  DefaultButton.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import UIKit
import RxSwift
import SnapKit

final class DefaultButton: UIButton {
    
    private var disposeBag = DisposeBag()
    
    private var configStorage = Config.empty()
    
    private var heightConstraint: ConstraintMakerEditable? = nil
    
    var config: Config {
        get { configStorage }
        set {
            configStorage = newValue
            setupConfig(config: newValue)
        }
    }
    
    // MARK: - Private methods
    
    private func setupConfig(config: Config) {
        disposeBag = DisposeBag()
        layer.reset()
        
        var configuration = Configuration.plain()
        configuration.title = config.title
        
        setupAttributed { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.manrope(
                type: .extraBold,
                size: 13
            )
            return outgoing
        }
        
        self.configuration = configuration
        if let action = config.action {
            alpha = 1
            rx.tap
                .subscribe(onNext: {
                    action()
                })
                .disposed(by: disposeBag)
        } else {
            alpha = 0.7
        }
        
        setupStyle(style: config.style)
        setupHeight(style: config.style)

        
    }
    
    private func setupAttributed(
        _ attributed: @escaping (AttributeContainer) -> AttributeContainer
    ) {
        configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer(attributed)
    }
    
    // MARK: - Setup stiles

    private func setupStyle(style: Style) {
        switch style {
        case .primary:
            setupPrimaryStyle()

        case .light:
            setupLightStyle()
            
        case .fullyRoundedPrimary:
            setupFullyRoundedPrimaryStyle()
            
        case .primaryPlus:
            setupPrimaryPlusStyle()

        case .simple:
            setupSimpleStyle()
            
        case .chekButton(let isSelected, let chekSubstile):
            setupChekButton(
                isSelected: isSelected,
                chekSubstile: chekSubstile
            )
            
        case .none:
            backgroundColor = .white
            configuration?.baseForegroundColor = .textColor
       
        }
        clipsToBounds = true
    }
    
    private func setupHeight(style: Style) {
        if let height = style.height {
            snp.remakeConstraints { make in
                heightConstraint = make.height
                    .equalTo(height)
            }
        } else {
            heightConstraint?.constraint
                .deactivate()
        }
    }
    
}

// MARK: - Make styles

extension DefaultButton {
    private func setupPrimaryStyle() {
        backgroundColor = .primary
        layer.cornerRadius = 12.0
        configuration?.baseForegroundColor = .white
    }
    
    private func setupLightStyle() {
        configuration?.baseForegroundColor = .primaryLight
    }
    
    private func setupFullyRoundedPrimaryStyle() {
        backgroundColor = .primary
        layer.cornerRadius = 25.0
        configuration?.baseForegroundColor = .white
    }
    
    private func setupPrimaryPlusStyle() {
        backgroundColor = .primary
        layer.cornerRadius = 12.0

        let imageConfig = UIImage.SymbolConfiguration(
            font: .manrope(
                type: .bold,
                size: 13
            )!
        )
        let image = UIImage.plus
            .withConfiguration(imageConfig)
        
        configuration?.image = image
        configuration?.baseForegroundColor = .white
    }
    
    private func setupChekButton(
        isSelected: Bool,
        chekSubstile: Style.CheckButtonSubstyle
    ) {
        let imageName = isSelected ? "checkmark.square.fill" : "square"
        configuration?.image = UIImage(systemName: imageName)
        configuration?.image?
            .withTintColor(.primary)
        let myAttribute = [
            NSAttributedString.Key.foregroundColor: UIColor.textColor
        ]
        let myAttrString = AttributedString(
            configuration?.title ?? "",
            attributes: AttributeContainer(myAttribute))
        
       
        configuration?.attributedTitle = myAttrString
        configuration?.imagePadding = 5
        configuration?.imagePlacement = .leading
        contentHorizontalAlignment = .leading
        configuration?.contentInsets = .zero
        
       
        setupAttributed { incoming in
            var outgoing = incoming
            switch         chekSubstile {
            case .light:
                outgoing.font = UIFont.manrope(
                    type: .regular,
                    size: 14
                )
            case .bold:
                outgoing.font = UIFont.manrope(
                    type: .bold,
                    size: 16
                )
            }
            
            return outgoing
        }
    }
    
    private func setupSimpleStyle() {
        backgroundColor = .white
        layer.cornerRadius = 12.0
        layer.borderColor = UIColor.border.cgColor
        layer.borderWidth = 2.0
        configuration?.baseForegroundColor = .textColor
    }
}


// MARK: - Config for button

extension DefaultButton {
    
    struct Config {
        var title: String
        var style: Style
        var action: (() -> Void)?
        
        static func empty() -> Config {
            return Config(
                title: "",
                style: .none
            )
        }
    }
    
    enum Style {
        case simple
        case light
        case primary
        case fullyRoundedPrimary
        case primaryPlus
        case chekButton(isSelected: Bool, substile: CheckButtonSubstyle)
        case none
        
        fileprivate var height: CGFloat? {
            switch self {
            case .fullyRoundedPrimary:
                return 50.0
                
            case .simple,
                    .primary,
                    .primaryPlus:
                return 40.0

            case .light,
                    .chekButton,
                    .none:
                return nil
            }
        }
        
        enum CheckButtonSubstyle {
            case light
            case bold
        }
    }
}

// MARK: - Custom binding

extension Reactive where Base: DefaultButton {
    var config: Binder<DefaultButton.Config> {
        return Binder(self.base) { button, config in
            button.config = config
        }
    }
}
