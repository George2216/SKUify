//
//  ExpensesCategoriesUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation
import Domain
import RxSwift

final class ExpensesCategoriesUseCase: Domain.ExpensesCategoriesUseCase {
    
    private let expensesCategoriesNetwork: Domain.ExpensesCategoriesNetwork
    private let expensesCategoriesDataUseCase: Domain.ExpensesCategoriesWriteDataUseCase
    
    init(
        expensesCategoriesNetwork: Domain.ExpensesCategoriesNetwork,
        expensesCategoriesDataUseCase: Domain.ExpensesCategoriesWriteDataUseCase
    ) {
        self.expensesCategoriesNetwork = expensesCategoriesNetwork
        self.expensesCategoriesDataUseCase = expensesCategoriesDataUseCase
    }
    
    func updateCategories() -> Observable<Void> {
        expensesCategoriesNetwork
            .getCategories()
            .flatMapLatest(weak: self) { owner, expenses in
                owner.expensesCategoriesDataUseCase
                    .updateCategories(expenses)
            }
    }
        
}
