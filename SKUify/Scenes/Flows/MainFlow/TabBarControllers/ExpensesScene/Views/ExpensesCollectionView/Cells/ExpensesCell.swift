//
//  ExpensesCell.swift
//  SKUify
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation
import UIKit
import SnapKit

final class ExpensesCell: UICollectionViewCell {
    
    // MARK: UI elements
    
    private lazy var contentStack = VerticalStack()
    
    private let spacing: CGFloat = 10.0

    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup views
    
    func setupInput(_ input: Input) {
        contentStack.views = input.content.map(makeMainView)
    }
    
    func setupWigth(_ width: CGFloat) {
        contentView.snp.makeConstraints { make in
            make.width
                .equalTo(width)
        }
    }
    
    // MARK: Private methods

    private func setupContentStack() {
        contentStack.spacing = spacing
        
        contentView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(spacing)
        }
    }
    
    private func setupCell() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    // MARK: - Factory methods

    private func makeMainView(_ input: ViewType) -> UIView {
        switch input {
        case .titledView(let input):
            return makeTitledView(input)
        case .smallButtons(let input):
            return makeSmallButtons(input)
        case .horizontalViews(let input):
            return makeHorizontalViews(input)
        case .none:
            return UIView()
        }
    }
    
    private func makeTitledView(_ input: TitledViewInput) -> UIView {
        let view = makeView(input.viewType)
        
        var titleAligment: NSTextAlignment = .left
        
        switch input.viewType {
        case .smallSwitch:
            titleAligment = .center
        default:
            titleAligment = .left
        }
        
        let titleDecorator = TitleDecorator(
            decoratedView: view,
            font: .manrope(
                type: .bold,
                size: 14
            ),
            textColor: .textColor,
            titleAligment: titleAligment
        )
        titleDecorator.decorate(title: input.title)
        return titleDecorator
    }
    
    private func makeView(_ input: TitledViewType) -> UIView {
        var view = UIView()
        
        switch input {
        case .button(let config):
            let button = DefaultButton()
            button.config = config
            view = button
        case .textField(let config):
            let textField = DefaultTextField()
            textField.config = config
            view = textField
        case .smallSwitch(let config):
            view = makeEqutableSmallSwitch(config)
        }
        
        view.snp.makeConstraints { make in
            make.height
                .equalTo(40)
        }
        
        return view
    }
    
    private func makeEqutableSmallSwitch(_ config: DefaultSmallSwitch.Config) -> UIView {
        let smallSwitch = DefaultSmallSwitch()
        smallSwitch.config = config
        
        let hStack = HorizontalStack()
        hStack.distribution = .fillEqually
        hStack.views = [
            UIView.spacer(),
            smallSwitch,
            UIView.spacer()
        ]
        return hStack
    }
    
    private func makeSmallButtons(_ input: [DefaultButton.Config]) -> UIView {
        var buttons: [UIView] = input
            .map { $0.toButton() }
       
        buttons.append(UIView.spacer())
        
        let hStack = HorizontalStack()
        hStack.spacing = 10.0
        hStack.views = buttons
        return hStack
    }
    
    private func makeHorizontalViews(_ input: [ViewType]) -> UIView {
        let hStack = HorizontalStack()
        hStack.views = input.map(makeMainView)
        hStack.spacing = 15.0
        hStack.distribution = .fillEqually
        hStack.alignment = .fill
        return hStack
    }
}

// MARK: View types

extension ExpensesCell {
    
    indirect enum ViewType {
        case titledView(_ input: TitledViewInput)
        case smallButtons(_ configs: [DefaultButton.Config])
        case horizontalViews(_ types: [ViewType])
        case none
    }
    
    struct TitledViewInput {
        let title: String
        let viewType: TitledViewType
    }
    
    enum TitledViewType {
        case button(_ config: DefaultButton.Config)
        case textField(_ config: DefaultTextField.Config)
        case smallSwitch(_ config: DefaultSmallSwitch.Config)
    }
    
}


// MARK: Input

extension ExpensesCell {
    struct Input {
        let content: [ViewType]
    }
    
}
