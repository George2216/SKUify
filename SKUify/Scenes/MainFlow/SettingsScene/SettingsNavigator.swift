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
    
    
    
    deinit {
        print("Deinit")
    }
    
}

