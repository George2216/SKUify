//
//  ExpenseTransactionsViewModel.swift
//  SKUify
//
//  Created by George Churikov on 31.05.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class ExpenseTransactionsViewModel: ViewModelProtocol {
    
    // Dependencies
    private let navigator: ExpenseTransactionsNavigatorProtocol
    
    private let expense: ExpenseDTO
    // Use case storage
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        expense: ExpenseDTO,
        useCases: ExpenseTransactionsUseCases,
        navigator: ExpenseTransactionsNavigatorProtocol
    ) {
        self.expense = expense
        self.navigator = navigator
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output(title: makeTitle())
    }
    
    private func makeTitle() -> Driver<String> {
        .just(expense.name + " " + "Transactions")
    }
    
}

extension ExpenseTransactionsViewModel {
    struct Input {
        
    }
    
    struct Output {
        let title: Driver<String>
    }
    
}
