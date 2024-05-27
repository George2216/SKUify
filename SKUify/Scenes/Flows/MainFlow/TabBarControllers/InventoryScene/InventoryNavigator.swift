//
//  InventoryNavigator.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import UIKit

protocol InventoryNavigatorProtocol {
    func toInventory()
    func toSettingsCOG(_ input: COGSettingsInputModel)
    func toCOG(_ input: COGInputModel)
}

final class InventoryNavigator: InventoryNavigatorProtocol {
 
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toInventory() {
        let vc = InventoryVC()
        vc.viewModel = InventoryViewModel(
            useCases: di,
            navigator: self
        )
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toCOG(_ input: COGInputModel) {
        let navigator = COGNavigator(
            navigationController: navigationController,
            di: di
        )
        navigator.toCOG(input)
    }
    
    func toSettingsCOG(_ input: COGSettingsInputModel) {
        let navigator = COGSettingsNavigator(
            navigationController: navigationController,
            di: di
        )
        navigator.toCOGSettings(input)
    }
    
    deinit {
        print("Deinit")
    }
    
}

