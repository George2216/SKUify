//
//  ExpenseTransactionsNavigator.swift
//  SKUify
//
//  Created by George Churikov on 31.05.2024.
//

import Foundation
import UIKit
import Domain

protocol ExpenseTransactionsNavigatorProtocol {
    func toTransactions(_ expense: ExpenseDTO)
}

final class ExpenseTransactionsNavigator: ExpenseTransactionsNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toTransactions(_ expense: ExpenseDTO) {
        let vc = ExpenseTransactionsVC()
        vc.viewModel = ExpenseTransactionsViewModel(
            expense: expense,
            useCases: di,
            navigator: self
        )
        vc.hidesBottomBarWhenPushed = true

        navigationController.pushViewController(vc)
        
    }
    
    deinit {
        print("Deinit")
    }
    
}

