//
//  ExpensesUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation
import Domain
import RxSwift

final class ExpensesUseCase: Domain.ExpensesUseCase {
    
    private let expensesNetwork: Domain.ExpensesNetwork
    private let updateExpensesNetwork: Domain.UpdateExpensesNetwork
    
    init(
        expensesNetwork: Domain.ExpensesNetwork,
        updateExpensesNetwork: Domain.UpdateExpensesNetwork
    ) {
        self.expensesNetwork = expensesNetwork
        self.updateExpensesNetwork = updateExpensesNetwork
    }
    
    func getExpenses(_ paginatedModel: ExpensesPaginatedModel) -> Observable<[ExpenseDTO]> {
        expensesNetwork
            .getExpensesNetwork(paginatedModel)
            .map { $0.results }
    }
    
    func updateExpenses(_ expenses: [ExpenseDTO]) -> Observable<[ExpenseDTO]> {
        updateExpensesNetwork
            .updateExpenses(expenses)
    }
    
}
