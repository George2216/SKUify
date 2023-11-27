//
//  BaseButton.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import UIKit
import RxSwift

class DefaultButton: UIButton {
    
    private var disposeBag = DisposeBag()
    
    private var configStorage = Config.empty()
    
    var config: Config {
        get { configStorage }
        set {
            configStorage = newValue
            setupConfig(config: newValue)
        }
    }
    
    private func setupConfig(config: Config) {
        disposeBag = DisposeBag()
        setTitle(config.title, for: .normal)
        
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
        
        switch config.style {
        case .background:
            backgroundColor = .lightGray
        }
        
    }
    
    struct Config {
        var title: String
        var style: Style
        var action: (() -> Void)?
        
        static func empty() -> Config {
            return Config(
                title: "",
                style: .background
            )
        }
    }
    
    enum Style {
        case background
    }
}

extension Reactive where Base: DefaultButton {
    var config: Binder<DefaultButton.Config> {
        return Binder(self.base) { button, config in
            button.config = config
        }
    }
}
