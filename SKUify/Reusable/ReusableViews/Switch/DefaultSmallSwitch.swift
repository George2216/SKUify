//
//  DefaultSmallSwitch.swift
//  SKUify
//
//  Created by George Churikov on 02.04.2024.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DefaultSmallSwitch: SmallSwitch {
    private var disposeBag = DisposeBag()

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
        
        setupSwitchState(config)
        setupSwitchAction(config)
    }
    
    private func setupSwitchState(_ config: Config) {
        isOn = config.state
    }
    
    private func setupSwitchAction(_ config: Config) {
        rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                config.switchChanged?(owner.isOn)
                config.state = owner.isOn
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: Config

extension DefaultSmallSwitch {
    class Config {
        var state: Bool = false
        var switchChanged: ((Bool) -> ())?
        
        static func empty() -> Config {
            .init()
        }
        
        init(
            state: Bool = false,
            switchChanged: ((Bool) -> Void)? = nil
        ) {
            self.state = state
            self.switchChanged = switchChanged
        }
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: DefaultSmallSwitch {
    var config: Binder<DefaultSmallSwitch.Config> {
        return Binder(self.base) { defaultSwitch, config in
            defaultSwitch.config = config
        }
    }
    
}
