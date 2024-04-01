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
       
        rx.controlEvent(config.controlEvent)
            .debounce(
                .milliseconds(config.debounce),
                scheduler: MainScheduler.instance
            )
            .withLatestFrom(rx.text.orEmpty)
            .asDriverOnErrorJustComplete()
            .drive(onNext: { text in
                config.textObserver(text)
            })
            .disposed(by: disposeBag)
        
        text = config.text
        
        setupStyle(style: config.style)
        setupPlaceholder(config: config)
        
        if !config.text.isEmpty {
            config.textObserver(config.text)
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
            layer.borderWidth = 1.0
            layer.cornerRadius = 10.0
            addLeftImage()
            
        case .search:
            layer.borderWidth = 2.0
            layer.cornerRadius = 12.0
            addLeftImage(.search, padding: 5)
            
        case .doubleBordered(let leftText):
            layer.borderWidth = 1.0
            layer.cornerRadius = 10.0
            delegate = doubleDelegate
            keyboardType = .asciiCapableNumberPad
            self.delegate = doubleDelegate

            textAlignment = .right

            addLeftText(leftText)
            addRightImage(padding: 16.0)


        }
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
    struct Config {
        var style: Style
        var text: String = ""
        var plaseholder: String = ""
        var debounce: Int = 0 // milliseconds
        var textObserver: ((String)->())
        var controlEvent: UIControl.Event = .editingChanged
        
        static func empty() -> Config {
            return Config(
                style: .bordered,
                textObserver: { _ in }
            )
        }
    }
    
    enum Style {
        case bordered
        case doubleBordered(_ leftText: String)
        case search
        
        fileprivate var height: CGFloat {
            switch self {
            case .bordered,
                    .doubleBordered:
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
