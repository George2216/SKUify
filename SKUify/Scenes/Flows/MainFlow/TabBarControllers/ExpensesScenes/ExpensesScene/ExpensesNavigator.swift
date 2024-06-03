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
        let vc = TransactionsVC()
        vc.title = "\(expense.name) Transactions"
        navigationController.pushViewController(vc, animated: true)
    }
    
    deinit {
        print("Deinit")
    }
    
}


final class TransactionsVC: BaseViewController {
    
    let label = UILabel()
    let infoText = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        label.text = "Here will be the transaction logic"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        infoText.text = "here will be the element data for which the transaction logic will be below"
        infoText.numberOfLines = 0
        infoText.textAlignment = .center
        
        
        view.addSubview(label)
        view.addSubview(infoText)

        infoText.snp.makeConstraints { make in
            make.centerX
                .equalToSuperview()
            make.top.equalToSuperview()
                .inset(100)
            make.horizontalEdges
                .equalToSuperview()
                .inset(50)
        }
        label.snp.makeConstraints { make in
            make.centerX
                .equalToSuperview()
            make.top.equalToSuperview()
                .inset(200)
            make.horizontalEdges
                .equalToSuperview()
                .inset(50)
            
        }
    }
    
}
