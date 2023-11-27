//
//  TitledTextField.swift
//  SKUify
//
//  Created by George Churikov on 22.11.2023.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TitledTextField: UIView {
    
    //MARK: - Subviews
    
    private let titleLabel = UILabel()
    private let textField = DefaultTextField()
    
    // MARK: - Input data for TitledTextField, automatically updating components

    private var inputStorage = Config.empty()
    
    var input: Config {
        get { inputStorage }
        set {
            inputStorage = newValue
            setupConfig(newValue)
        }
    }
    
    //MARK: - Private methods

    private func setupConfig(_ config: Config) {
        titleLabel.text = config.title
        textField.rx.config.onNext(config.config)
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .bold,
            size: 14
        )
        titleLabel.textColor = .textColor
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges
                .top
                .equalToSuperview()
        }
    }
    
    private func setupTextField() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(7)
            make.horizontalEdges
                .bottom
                .equalToSuperview()
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleLabel()
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Config

extension TitledTextField {
    struct Config {
        let title: String
        let config: DefaultTextField.Config
        
        static func empty() -> Self {
            .init(
                title: "",
                config: .empty()
            )
        }
        
        func createFromInput() -> TitledTextField {
            let txtField = TitledTextField()
            txtField.input = self
            return txtField
        }
    }
}

// MARK: - Custom binding

extension Reactive where Base: TitledTextField {
    var config: Binder<TitledTextField.Config> {
        return Binder(self.base) { view, input in
            view.input = input
        }
    }
}
