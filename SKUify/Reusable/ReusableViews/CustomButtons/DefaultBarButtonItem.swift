//
//  DefaultBarButtonItem.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import UIKit
import RxSwift

final class DefaultBarButtonItem: UIBarButtonItem {
    fileprivate var disposeBag = DisposeBag()
    
    private var configStorage = Config.empty()
    
    var config: Config {
        get { configStorage }
        set {
            configStorage = newValue
            setupConfig(newValue)
        }
    }
    
    private func setupConfig(_ config: Config) {
        setupStyle(config.style)
        setupAction(config.actionType)
    }
    
    private func setupStyle(_ style: Style) {
        let button = UIButton()
        switch style {
        case .textable(let text):
            button.setTitle(text, for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)

        case .image(let image):
            button.setImage(image, for: .normal)
            button.tintColor = .systemBlue
        }
        
        button.frame = .init(
            origin: .zero,
            size: .init(
                width: 30,
                height: 30
            )
        )
        customView = button
    }
    
    private func setupAction(_ actionType: ActionType?) {
        if let button = customView as? UIButton,
            let actionType {
            button.rx.tap
                .subscribe(onNext: {
                    switch actionType {
                    case .base(let action):
                        action?()
                    case .popUp(let action):
                        action?(button.centerOfView())
                    }
                })
                .disposed(by: disposeBag)
        }
        
    }
    
}

// MARK: - Configuration

extension DefaultBarButtonItem {
    
    struct Config {
        let style: Style
        var actionType: ActionType? = nil
        
       static func empty() -> Config {
            return .init(
                style: .textable(""),
                actionType: .base(nil)
            )
        }
    }
    
    enum Style {
        case image(_ image: UIImage)
        case textable(_ text: String)
        
        enum ImageType {
        case settings
        case notification
        case currency
        case titleImage
            
            var image: UIImage {
                switch self {
                case .settings:
                    return .settings
                case .notification:
                    return .notification
                case .currency:
                    return .currency
                case .titleImage:
                    return .titleImage
                }
            }
        }
    }
    
    enum ActionType {
        case base(_ action: (() -> Void)?)
        case popUp(_ action: ((CGPoint) -> Void)?)
    }
    
    
    
}

// MARK: - Custom binding

extension Reactive where Base: DefaultBarButtonItem {
    var config: Binder<DefaultBarButtonItem.Config> {
        return Binder(self.base) { button, config in
            button.disposeBag = DisposeBag()
            button.config = config
        }
    }
}
