//
//  SettingsVC.swift
//  SKUify
//
//  Created by George Churikov on 01.12.2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SettingsVC: BaseViewController {
    
    var viewModel: SettingsViewModel!
    
    // MARK: - UI Elements
    
    private let versionLabel = UILabel()
    private let logoutButton = LogoutSettingsButton()
    private let contentStack = VerticalStack()
    private let defaultButtonsStack = VerticalStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        let output = viewModel.transform(.init())
        contentStackToSubview()
        setupContentStack()
        setupDefaultButtonsStack()
        setupLabelVersion()
        bindToDefaultButtonsStack(output)
        bindToLogoutButton(output)
        bindToVersionLabel(output)
        bindToAlert(output)
    }
    
    
    private func bindToDefaultButtonsStack(_ output: SettingsViewModel.Output) {
        output.defaultSettingsButtonConfigs.map { items in
            items.map { $0.toButton() }
        }
        .drive(defaultButtonsStack.rx.views)
        .disposed(by: disposeBag)
    }
    
    private func bindToLogoutButton(_ output: SettingsViewModel.Output) {
        output.logoutButtonConfig
            .drive(logoutButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToVersionLabel(_ output: SettingsViewModel.Output) {
        output.appVersionLabelText
            .drive(versionLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindToAlert(_ output: SettingsViewModel.Output) {
        output.alert
            .drive(rx.alert)
            .disposed(by: disposeBag)
    }
    
    private func setupLabelVersion() {
        versionLabel.textColor = .textColor
        versionLabel.textAlignment = .center
        versionLabel.font = .manrope(
            type: .bold,
            size: 15
        )
    }
    
    private func setupDefaultButtonsStack() {
        defaultButtonsStack.spacing = 15
    }
    
    private func setupContentStack() {
        contentStack.spacing = 15

        contentStack.layoutMargins = UIEdgeInsets(
            top: 20,
            left: 16,
            bottom: 20,
            right: 16
        )
        contentStack.isLayoutMarginsRelativeArrangement = true

        contentStack.views = [
            defaultButtonsStack,
            UIView.spacer(),
            logoutButton,
            versionLabel
        ]
    }
    
    private func contentStackToSubview() {
        view.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

