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
    
    // MARK: - To update the borderColor after changing the theme, as the color for the layer does not change.
    // Set border color to borderColorStorage

    var borderColorStorage: UIColor? = nil {
        didSet {
            layer.borderColor = borderColorStorage?.cgColor
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.borderColor = borderColorStorage?.cgColor
    }
    
    // MARK: - Private methods
    
    private func setupConfig(config: Config) {
        // Clear all
        disposeBag = DisposeBag()
        layer.reset()
        borderColorStorage = nil
        
        var configuration = Configuration.plain()
        configuration.title = config.title
        self.configuration = configuration

        setupTextFont(
            .manrope(
                type: .bold,
                size: 15
            )
        )
        
        setupAction(config)
        
        setupStyle(style: config.style)
        setupHeight(style: config.style)
    }
    
    private func setupAction(_ config: Config) {
        let inactiveAlpha = 0.7
        if let actionType = config.action {
            alpha = 1
            rx.tap
                .withUnretained(self)
                .subscribe(onNext: { owner, _ in
                    switch actionType {
                    case .simple(let action):
                        action?()
                    case .point(let action):
                        action?(owner.centerOfView())
                    }
                })
                .disposed(by: disposeBag)
            
            switch actionType {
            case .simple(let action):
                guard action == nil else { return }
                alpha = inactiveAlpha

            case .point(let action):
                guard action == nil else { return }
                alpha = inactiveAlpha
            }
            
        } else {
            alpha = inactiveAlpha
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
            
        case .primaryRed:
            setupPrimaryRed()
            
        case .light:
            setupLightStyle()
            
        case .fullyRoundedPrimary:
            setupFullyRoundedPrimaryStyle()

        case .primaryPlus:
            setupPrimaryPlusStyle()
            
        case .primaryMore:
            setupPrimaryMoreStyle()

        case .lightPrimaryPlus:
            setupLightPrimaryPlusStyle()
            
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
      
        case .infoButton:
            setupInfoButton()
            
        case .custom(let radius, let background, let tint, let image, let borderWidth, let borderColor):
            backgroundColor = background.color
            tintColor = tint.color
            configuration?.image = image?.image
            layer.borderWidth = borderWidth
            borderColorStorage = borderColor.color
            layer.cornerRadius = radius
            layer.masksToBounds = true
            
        case .none:
            backgroundColor = .cellColor
            configuration?.baseForegroundColor = .textColor
      
        case .simplePrimaryText:
            setupSimplePrimaryText()
            
        case .cog:
            setupCogButton()
            
        case .vat:
             setupVatButton()
            
        case .popover:
            setupPopoverButton()
            
        case .calendarPopover:
            setupCalendarPopoverStyle()
        }
        
        clipsToBounds = true
    }
    
    private func setupHeight(style: Style) {
        if let height = style.height {
            snp.makeConstraints({ make in
                heightConstraint = make.height
                    .equalTo(height)
            })
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
        backgroundColor = .subtextColor
        configuration?.baseForegroundColor = .background
    }
    
    private func setupPrimaryRed() {
        setupPrimaryStyle()
        backgroundColor = .systemRed
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
    
    private func setupPrimaryMoreStyle() {
        backgroundColor = .primaryLight
        layer.cornerRadius = 12.0

        let imageConfig = UIImage.SymbolConfiguration(
            font: .manrope(
                type: .bold,
                size: 13
            )
        )
        let image = UIImage(systemName: "chevron.right")?
            .withConfiguration(imageConfig)
        
        configuration?.image = image
        configuration?.baseForegroundColor = .white
        configuration?.imagePlacement = .trailing
    }
    
    private func setupLightPrimaryPlusStyle() {
        setupPrimaryPlusStyle()
        backgroundColor = .primaryLight
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
        backgroundColor = .cellColor
        configuration?.baseForegroundColor = .label
        layer.cornerRadius = 12.0
        borderColorStorage = .border
        
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
    
    private func setupPopoverButton() {
        tintColor = .tertiaryTextColor
        let imageConfig = UIImage.SymbolConfiguration(
            font: .manrope(
                type: .semiBold,
                size: 10
            )
        )
        layer.borderWidth = 1.0
        layer.cornerRadius = 12.0
        borderColorStorage = .border
        
        backgroundColor = .field

        configuration?.image = UIImage(
            systemName: "chevron.down",
            withConfiguration: imageConfig
        )
        configuration?.imageColorTransformer = UIConfigurationColorTransformer { _ in .systemBlue }
        contentHorizontalAlignment = .fill
        configuration?.imagePlacement = .trailing
    
        setupTextFont(
            .manrope(
                type: .medium,
                size: 13
            )
        )
    
    }
    
    private func setupCalendarPopoverStyle() {
        tintColor = .tertiaryTextColor
        let imageConfig = UIImage.SymbolConfiguration(
            font: .manrope(
                type: .semiBold,
                size: 10
            )
        )
        layer.borderWidth = 1.0
        layer.cornerRadius = 12.0
        borderColorStorage = .border
        
        backgroundColor = .field

        configuration?.image = .calendar
            .withConfiguration(imageConfig)
       
        contentHorizontalAlignment = .fill
        configuration?.imagePlacement = .trailing
    
        setupTextFont(
            .manrope(
                type: .medium,
                size: 13
            )
        )
    }

}

// MARK: - Config for button

extension DefaultButton {
    
    struct Config {
        var title: String
        var style: Style
        var action: ActionType?
        
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
    
    enum ActionType {
        case simple(_ action: (()->())?)
        // center button
        case point(_ action: ((CGPoint)->())?)
    }
    
    enum Style {
        case simple
        case light
        case primary
        case primaryGray
        case primaryRed
        case fullyRoundedPrimary
        case primaryPlus
        case primaryMore
        case lightPrimaryPlus
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
        case popover
        case calendarPopover
        
        fileprivate var height: CGFloat? {
            switch self {
            case .fullyRoundedPrimary:
                return 50.0
                
            case .simple,
                    .simplePrimaryText,
                    .primary,
                    .primaryGray,
                    .primaryRed,
                    .primaryPlus,
                    .lightPrimaryPlus:
                return 40.0

            case .light,
                    .chekButton,
                    .none,
                    .image,
                    .infoButton,
                    .custom,
                    .cog,
                    .vat,
                    .popover,
                    .calendarPopover,
                    .primaryMore
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
        case deleteLight
        case more
        
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
            case .deleteLight:
                return .deleteLight
            case .more:
                return .more
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
                return .label
            case .clear:
                return .clear
            case .lightGray:
                return .lightGray
            case .red:
                return .systemRed
            case .primary:
                return .primary
            case .white:
                return .cellColor
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
