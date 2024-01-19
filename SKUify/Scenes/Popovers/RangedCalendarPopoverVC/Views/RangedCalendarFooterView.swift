//
//  RangedCalendarFooterView.swift
//  SKUify
//
//  Created by George Churikov on 15.01.2024.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RangedCalendarFooterView: UIView {
    fileprivate var disposeBag = DisposeBag()

    // MARK: UI elements

    private lazy var startDateLabel = UILabel()
    private lazy var endDateLabel = UILabel()
    private lazy var separatorLabel = UILabel()
    
    private lazy var confirmButton = DefaultButton()
    
    private lazy var labelsStack = HorizontalStack()
    private lazy var contentStack = HorizontalStack()
    
    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSeparatorLabel()
        setupStartDateLabel()
        setupEndDateLabel()
        setupLabelsStack()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Make binding to views

    fileprivate func makeBinding(_ input: Input) {
        bindToSeparatorLabel(input)
        bindToEndDateLabel(input)
        bindToStartDateLabel(input)
        bindToConfirmButton(input)
    }
    
    private func bindToSeparatorLabel(_ input: Input) {
        input.separator
            .drive(separatorLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindToEndDateLabel(_ input: Input) {
        input.endDate
            .drive(endDateLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindToStartDateLabel(_ input: Input) {
        input.startDate
            .drive(startDateLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindToConfirmButton(_ input: Input) {
        input.confirmButtonConfig
            .drive(confirmButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    // MARK: Setup views
    
    private func setupContentStack() {
        contentStack.views = [
            labelsStack,
            UIView.spacer(),
            confirmButton
        ]
        contentStack.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 10,
            right: 10
        )
        contentStack.isLayoutMarginsRelativeArrangement = true
        
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
    private func setupLabelsStack() {
        labelsStack.views = [
            startDateLabel,
            separatorLabel,
            endDateLabel
        ]
        labelsStack.distribution = .equalSpacing
    }
    
    private func setupSeparatorLabel() {
        setupLabelAttributed(&separatorLabel)
    }
    
    private func setupStartDateLabel() {
        setupLabelAttributed(&startDateLabel)
    }
    
    private func setupEndDateLabel() {
        setupLabelAttributed(&endDateLabel)
    }
    
    private func setupLabelAttributed(_ label: inout UILabel) {
        label.font = .manrope(
            type: .regular,
            size: 13
        )
        label.textColor = .primary
        label.textAlignment = .left
    }
    
}

// MARK: Input

extension RangedCalendarFooterView {
    struct Input {
        let startDate: Driver<String>
        let endDate: Driver<String>
        let separator: Driver<String>
        let confirmButtonConfig: Driver<DefaultButton.Config>
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: RangedCalendarFooterView {
    var input: Binder<RangedCalendarFooterView.Input> {
        return Binder(self.base) { view, input in
            view.disposeBag = DisposeBag()
            view.makeBinding(input)
        }
    }
    
}
