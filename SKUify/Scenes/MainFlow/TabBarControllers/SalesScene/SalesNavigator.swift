//
//  SalesNavigator.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import UIKit

protocol SalesNavigatorProtocol {
    func toSales()
    func toCOG()
}

final class SalesNavigator: SalesNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol

    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toSales() {
       let vc = SalesVC()
        vc.viewModel = SalesViewModel(
            useCases: di,
            navigator: self
        )
        navigationController.pushViewController(
            vc,
            animated: true
        )
    }
    
    func toCOG() {
        let navigator = COGNavigator(
            navigationController: navigationController,
            di: di
        )
        navigator.toCOG()
    }
    
    deinit {
        print("Deinit")
    }
    
}



