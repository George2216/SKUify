//
//  ExpensesNetwork.swift
//  Domain
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation
import RxSwift

public protocol ExpensesNetwork {
    func getExpensesNetwork(_ paginatedModel: ExpensesPaginatedModel) -> Observable<ExpensesResultsDTO>
}
