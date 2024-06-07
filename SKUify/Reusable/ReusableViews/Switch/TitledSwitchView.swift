//
//  TitledSwitchView.swift
//  SKUify
//
//  Created by George Churikov on 19.02.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TitledSwitchView: UIView {
    private var disposeBag = DisposeBag()

    // MARK: UI elements
    
    private lazy var titleLabel = UILabel()
    private lazy var smallSwitch = SmallSwitch()
    
    private lazy var contentStack = HorizontalStack()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitleLabel()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        disposeBag = DisposeBag()
        setupTitleText(input)
        setupSwitchState(input)
        setupSwitchAction(input)
    }
    
    private func setupTitleText(_ input: Input) {
        titleLabel.text = input.title
    }
    
    private func setupSwitchState(_ input: Input) {
        smallSwitch.isOn = input.switchState
    }
    
    private func setupSwitchAction(_ input: Input) {
        smallSwitch.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                input.switchChanged?(owner.smallSwitch.isOn)
            })
            .disposed(by: disposeBag)
           
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .bold,
            size: 14
        )
        titleLabel.textAlignment = .left
        titleLabel.textColor = .textColor
    }
    
    private func setupContentStack() {
        contentStack.views = [
            titleLabel,
            smallSwitch
        ]
        contentStack.alignment = .fill
        contentStack.distribution = .equalCentering
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

// MARK: Input

extension TitledSwitchView {
    struct Input {
        let title: String
        let switchState: Bool
        let switchChanged: ((Bool) -> ())?
    }
}
