//
//  ExpensesUseCase.swift
//  Domain
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation
import RxSwift

public protocol ExpensesUseCase {
    func getExpenses(_ paginatedModel: ExpensesPaginatedModel) -> Observable<[ExpenseDTO]>
    func updateExpenses(_ expenses: [ExpenseDTO]) -> Observable<[ExpenseDTO]>
}
