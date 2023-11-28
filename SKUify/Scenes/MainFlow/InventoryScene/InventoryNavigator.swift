//
//  InventoryNavigator.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import UIKit

protocol InventoryNavigatorProtocol {
    func toInventory()
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
    
    deinit {
        print("Deinit")
    }
    
}

