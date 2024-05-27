//
//  NewExpenseNavigator.swift
//  SKUify
//
//  Created by George Churikov on 23.05.2024.
//

import Foundation
import UIKit

protocol NewExpenseNavigatorProtocol {
    func toNewExpense()
    func toBack()
}

final class NewExpenseNavigator: NewExpenseNavigatorProtocol {
    private let navigationController: UINavigationController
    private let di: DIProtocol
    
    init(
        navigationController: UINavigationController,
        di: DIProtocol
    ) {
        self.navigationController = navigationController
        self.di = di
    }
    
    func toNewExpense() {
        let vc = ExpensesVC()
        vc.viewModel = NewExpenseViewModel(
            useCases: di,
            navigator: self
        )
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
        }

        navigationController.present(nav, animated: true)
    }
    
    func toBack() {
        navigationController.dismiss(animated: true)
    }
    
    deinit {
        print("Deinit")
    }
    
}

