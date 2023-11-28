//
//  ExpensesNavigator.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import UIKit

protocol ExpensesNavigatorProtocol {
    func toExpenses()
}

final class ExpensesNavigator: ExpensesNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol

    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toExpenses() {
       let vc = ExpensesVC()
        vc.viewModel = ExpensesViewModel(
            useCases: di,
            navigator: self
        )
    }
    
    deinit {
        print("Deinit")
    }
    
}

