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
        disposeBag = DisposeBag()
       
        rx.controlEvent(config.controlEvent)
            .withLatestFrom(rx.text.orEmpty)
            .asDriverOnErrorJustComplete()
            .drive(onNext: { text in
                config.textObserver(text)
            })
            .disposed(by: disposeBag)
        
        text = config.text
        setupStyle(style: config.style)
        
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
            
        }
    }
    
}

// MARK: - Config

extension DefaultTextField {
    struct Config {
        var style: Style
        var text: String = ""
        var plaseholder: String = ""
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
        case search
        
        fileprivate var height: CGFloat {
            switch self {
            case .bordered:
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
