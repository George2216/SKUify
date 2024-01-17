//
//  RangedCalendarHeaderView.swift
//  SKUify
//
//  Created by George Churikov on 12.01.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RangedCalendarHeaderView: UIView {
    fileprivate var disposeBag = DisposeBag()

    // MARK: UI elements

    private lazy var monthLabel = UILabel()
    private lazy var yearLabel = UILabel()
   
    private lazy var backButton = DefaultButton()
    private lazy var forvardButton = DefaultButton()
    
    private lazy var labelsStack = VerticalStack()
    private lazy var contentStack = HorizontalStack()
    
    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMonthLabel()
        setupYearLabel()
        setupBackButton()
        setupForvardButton()
        setupLabelsStack()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Make binding to views

    fileprivate func makeBinding(_ input: Input) {        
        bindToMonthLabel(input)
        bindToYearLabel(input)
        bindToBackButton(input)
        bindToForwardButton(input)
    }
    
    private func bindToMonthLabel(_ input: Input) {
        input.month
            .drive(monthLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindToYearLabel(_ input: Input) {
        input.year
            .drive(yearLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindToBackButton(_ input: Input) {
        input.backButtonConfig
            .drive(backButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToForwardButton(_ input: Input) {
        input.forwardButtonConfig
            .drive(forvardButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Setup views

    private func setupContentStack() {
        contentStack.views = [
            backButton,
            labelsStack,
            forvardButton
        ]
        contentStack.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 0,
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
            monthLabel,
            yearLabel
        ]
        labelsStack.distribution = .fillProportionally
    }
    
    private func setupYearLabel() {
        yearLabel.textAlignment = .center
        yearLabel.textColor = .darkGray
        yearLabel.font = .manrope(
            type: .medium,
            size: 12
        )
        addSubview(yearLabel)
    }
    
    private func setupMonthLabel() {
        monthLabel.textAlignment = .center
        monthLabel.font = .manrope(
            type: .medium,
            size: 20
        )
    }
    
    private func setupBackButton() {
        backButton.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
    private func setupForvardButton() {
        forvardButton.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
}

// MARK: - Input

extension RangedCalendarHeaderView {
    struct Input {
        let month: Driver<String>
        let year: Driver<String>
        let backButtonConfig: Driver<DefaultButton.Config>
        let forwardButtonConfig: Driver<DefaultButton.Config>
    }
    
}

// MARK: - Custom binding

extension Reactive where Base: RangedCalendarHeaderView {
    var input: Binder<RangedCalendarHeaderView.Input> {
        return Binder(self.base) { view, input in
            view.disposeBag = DisposeBag()
            view.makeBinding(input)
        }
    }
    
}
