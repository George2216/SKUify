//
//  ExpensesNavigator.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import UIKit
import SnapKit
import Domain

protocol ExpensesNavigatorProtocol {
    func toExpenses()
    func toNewExpense()
    func toTransactions(_ expense: ExpenseDTO)
    func backToExpenses()
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
            navigator: self, 
            expensesType: .allExpenses
        )
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toNewExpense() {
        let vc = ExpensesVC()
         vc.viewModel = ExpensesViewModel(
             useCases: di,
             navigator: self,
             expensesType: .newExpense
         )
         
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .currentContext
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance

        navigationController.tabBarController?.present(nav, animated: true)
    }
    
    func backToExpenses() {
        navigationController.dismiss(animated: true)
    }
    
    func toTransactions(_ expense: ExpenseDTO) {
       let navigator = ExpenseTransactionsNavigator(
        navigationController: navigationController,
        di: di
       )
        navigator.toTransactions(expense)
    }
    
    deinit {
        print("Deinit")
    }
    
}
