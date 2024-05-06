//
//  DefaultTextField.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//
import UIKit
import RxSwift
import RxCocoa
import RxRelay

final class DefaultTextField: UITextField {
    
    private var disposeBag = DisposeBag()
        
    // MARK: - Input data for DefaultTextField, automatically updating components

    private var doubleDelegate = DoubleTextFieldDelegate()
    
    private var configStorage = Config.empty()
    
    var config: Config {
        get { configStorage }
        set {
            configStorage = newValue
            setupConfig(config: newValue)
        }
    }
    
    //MARK: - Private methods

    private func setupConfig(config: Config) {
        delegate = nil
        disposeBag = DisposeBag()
       
        text = config.text

        rx.controlEvent(config.controlEvent)
            .debounce(
                .milliseconds(config.debounce),
                scheduler: MainScheduler.instance
            )
            .withLatestFrom(rx.text.orEmpty)
            .asDriverOnErrorJustComplete()
            .withUnretained(self)
            .drive(onNext: { owner, text in
                config.textObserver(text)
                owner.config.text = text
            })
            .disposed(by: disposeBag)
        
        
        setupStyle(style: config.style)
        setupPlaceholder(config: config)
        
        if !config.text.isEmpty {
            config.textObserver(config.text)
        }
        
        isEnabled = !config.lockInput
        
        if config.lockInput {
            backgroundColor = .background
        }
       
    }
 
    private func setupStyle(style: Style) {
        backgroundColor = .white
        font = .manrope(type: .bold, size: 14)
        textColor = .textColor
        
        layer.reset()
        layer.borderColor = UIColor.border.cgColor
        
        snp.makeConstraints { make in
            make.height
                .equalTo(style.height)
        }
        
        switch style {
        case .bordered:
            setupBorderedStyle()
            addLeftImage()
            
        case .search:
            layer.borderWidth = 2.0
            layer.cornerRadius = 12.0
            addLeftImage(.search, padding: 5)
            
        case .doubleBordered(let leftText):
            setupBorderedStyle()
            keyboardType = .asciiCapableNumberPad
            self.delegate = doubleDelegate

            textAlignment = .right

            addLeftText(leftText)
            addRightImage(padding: 16.0)

        case .intBordered:
            setupBorderedStyle()
            keyboardType = .numberPad

            textAlignment = .right

            addLeftImage(padding: 16.0)
            addRightImage(padding: 16.0)

        }
        
    }
    
    private func setupBorderedStyle() {
        layer.borderWidth = 1.0
        layer.cornerRadius = 10.0
    }
    
    private func setupPlaceholder(config: Config) {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightSubtextColor,
            .font: UIFont.manrope(
                type: .medium,
                size: 14
            )
        ]

        attributedPlaceholder = NSAttributedString(
            string: config.plaseholder,
            attributes: attributes
        )
    }
}

// MARK: - Config

extension DefaultTextField {
    // For configuration, we use a class so that when the text changes, we can modify the configuration of DefaultTextField, and this changes the initial configuration instance. This is necessary when using a textField on a table.
    class Config {
        var style: Style = .bordered
        var text: String = ""
        var plaseholder: String = ""
        var debounce: Int = 0 // milliseconds
        var textObserver: ((String)->()) = { _ in }
        var controlEvent: UIControl.Event = .editingChanged
        var lockInput: Bool = false
        static func empty() -> Config {
            return Config.init()
        }
        
        init(
            style: Style = .bordered,
            text: String = "",
            plaseholder: String = "",
            debounce: Int = 0,
            textObserver: @escaping (String) -> Void = {_ in },
            controlEvent: UIControl.Event = .editingChanged,
            lockInput: Bool = false
        ) {
            self.style = style
            self.text = text
            self.plaseholder = plaseholder
            self.debounce = debounce
            self.textObserver = textObserver
            self.controlEvent = controlEvent
            self.lockInput = lockInput
        }
        
    }
    
    enum Style {
        case bordered
        case intBordered
        case doubleBordered(_ leftText: String)
        case search
        
        fileprivate var height: CGFloat {
            switch self {
            case .bordered,
                    .doubleBordered,
                    .intBordered:
                return 40.0
            case .search:
                return 34.0
            }
        }
    }

}

extension Reactive where Base: DefaultTextField {
    var config: Binder<DefaultTextField.Config> {
        return Binder(self.base) { textField, config in
            textField.config = config
        }
    }
    
}
