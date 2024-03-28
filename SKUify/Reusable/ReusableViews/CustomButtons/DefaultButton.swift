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
    
    fileprivate var disposeBag = DisposeBag()
    
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
        layer.reset()
        
        var configuration = Configuration.plain()
        configuration.title = config.title

        setupTextFont(
            .manrope(
                type: .bold,
                size: 15)
        )
        
        setupAction(config)
        
        self.configuration = configuration
        
        
        setupStyle(style: config.style)
        setupHeight(style: config.style)
    }
    
    private func setupAction(_ config: Config) {
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
    }
    
    private func setupTextFont(_ font: UIFont?) {
        setupAttributed { incoming in
            var outgoing = incoming
            outgoing.font = font
            return outgoing
        }
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

        case .primaryGray:
            setupPrimaryGrey()
            
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
            
        case .image(let image):
            configuration?.image = image.image
            configuration?.contentInsets = .zero
            configuration?.imagePlacement = .all
      
        case .infoButton:
            setupInfoButton()
            
        case .custom(let radius, let background, let tint, let image, let borderWidth, let borderColor):
            backgroundColor = background.color
            tintColor = tint.color
            configuration?.image = image?.image
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.color.cgColor
            layer.cornerRadius = radius
            layer.masksToBounds = true
            
        case .none:
            backgroundColor = .white
            configuration?.baseForegroundColor = .textColor
      
        case .simplePrimaryText:
            setupSimplePrimaryText()
            
        case .cog:
            setupCogButton()
            
        case .vat:
             setupVatButton()
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
    
    private func setupPrimaryGrey() {
        setupPrimaryStyle()
        backgroundColor = .lightSubtextColor
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
            )
        )
        let image = UIImage.plus
            .withConfiguration(imageConfig)
        
        configuration?.image = image
        configuration?.baseForegroundColor = .white
    }
    
    private func setupChekButton(
        isSelected: Bool,
        chekSubstile: CheckButtonSubstyle
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
        
       
        switch chekSubstile {
        case .light:
            setupTextFont(
                .manrope(
                    type: .regular,
                    size: 14
                )
            )
        case .bold:
            setupTextFont(
                .manrope(
                    type: .bold,
                    size: 16
                )
            )
        }
       
    }
    
    private func setupInfoButton() {
        let imageConfig = UIImage.SymbolConfiguration(
            font: .manrope(
                type: .bold,
                size: 12
            )
        )
        configuration?.image = UIImage(systemName: "info.circle.fill")?
            .withConfiguration(imageConfig)
        configuration?.imagePadding = 5
        configuration?.imagePlacement = .trailing
        configuration?.baseForegroundColor = .textColor
        configuration?.contentInsets = .zero

        setupTextFont(
            .manrope(
                type: .bold,
                size: 12
            )
        )
    }
    
    private func setupSimpleStyle() {
        backgroundColor = .white
        configuration?.baseForegroundColor = .black
        layer.cornerRadius = 12.0
        layer.borderColor = UIColor.border.cgColor
        layer.borderWidth = 2.0
    }
    
    private func setupSimplePrimaryText() {
        setupSimpleStyle()
        configuration?.baseForegroundColor = .primary
    }
    
    private func setupCogButton() {
        tintColor = .textColor
        
        configuration?.image = UIImage.pensill
        configuration?.imagePlacement = .trailing
        configuration?.titleAlignment = .leading
        configuration?.contentInsets = .zero

        contentHorizontalAlignment = .leading
        
        setupTextFont(
            .manrope(
                type: .bold,
                size: 15
            )
        )
    }
    
    private func setupVatButton() {
        configuration?.title = config.title
        configuration?.baseForegroundColor = .white
        
        backgroundColor = .primaryPink
        
        layer.cornerRadius = 7.0
        layer.masksToBounds = true
        
        setupTextFont(
            .manrope(
                type: .bold,
                size: 12
            )
        )
    
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
        
        func toButton() -> DefaultButton {
            let button = DefaultButton()
            button.config = self
            return button
        }
        
    }
    
    enum Style {
        case simple
        case light
        case primary
        case primaryGray
        case fullyRoundedPrimary
        case primaryPlus
        case simplePrimaryText
        case vat
        case chekButton(
            isSelected: Bool,
            substile: CheckButtonSubstyle
        )
        case image(_ image: ImageType)
        case infoButton
        case custom(
            radius: CGFloat = 0.0,
            backgroung: Color = .clear,
            tint: Color = .clear,
            image: ImageType? = nil,
            borderWidth: CGFloat = 0.0,
            borderColor: Color = .clear
        )
        case cog
        case none
        
        fileprivate var height: CGFloat? {
            switch self {
            case .fullyRoundedPrimary:
                return 50.0
                
            case .simple,
                    .simplePrimaryText,
                    .primary,
                    .primaryGray,
                    .primaryPlus:
                return 40.0

            case .light,
                    .chekButton,
                    .none,
                    .image,
                    .infoButton,
                    .custom,
                    .cog,
                    .vat
                :
                return nil
            }
        }
    }
    
    enum CheckButtonSubstyle {
        case light
        case bold
    }
    
    enum ImageType {
        case back
        case forward
        case notes
        case noteAdded
        case pensill
        case amazon
        case sellerCentral
        case add
        case tax
        case delete
        
        var image: UIImage? {
            switch self {
            case .back:
                return UIImage(systemName: "chevron.left")
            case .forward:
                return UIImage(systemName: "chevron.right")
            case .notes:
                return .notes
            case .noteAdded:
                return .noteAdded
            case .pensill:
                return .pensill
            case .amazon:
                return .amazon
            case .sellerCentral:
                return .sellerCentral
            case .add:
                return .add
            case .tax:
                return .taxSettings
            case .delete:
                return .delete
            }
        }
    }
    
    enum Color {
        case black
        case clear
        case lightGray
        case red
        case primary
        case white
        
        var color: UIColor {
            switch self {
            case .black:
                return .black
            case .clear:
                return .clear
            case .lightGray:
                return .lightGray
            case .red:
                return .systemRed
            case .primary:
                return .primary
            case .white:
                return .white
            }
        }
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: DefaultButton {
    var config: Binder<DefaultButton.Config> {
        return Binder(self.base) { button, config in
            button.disposeBag = DisposeBag()
            button.config = config
        }
    }
    
}
