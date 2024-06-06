//
//  SettingsNavigator.swift
//  SKUify
//
//  Created by George Churikov on 01.12.2023.
//

import Foundation
import UIKit

protocol SettingsNavigatorProtocol {
    func toSettings()
    func toProfile()
    func toCompanyInformation()
    func toSecurity()
}

final class SettingsNavigator: SettingsNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toSettings() {
        let vc = SettingsVC()
        vc.viewModel = SettingsViewModel(
            useCases: di,
            navigator: self
        )
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toProfile() {
        let profileNavigator = ProfileNavigator(
            navigationController: navigationController,
            di: di
        )
        profileNavigator.toProfile()
    }
    
    func toCompanyInformation() {
        let companyInformationNavigator = CompanyInformationNavigator(
            navigationController: navigationController,
            di: di
        )
        companyInformationNavigator.toCompanyInformation()
    }
    
    func toSecurity() {
        let navigator = SecurityNavigator(
            navigationController: navigationController,
            di: di
        )
        navigator.toSecurity()
    }
    
    
    deinit {
        print("Deinit")
    }
    
}

