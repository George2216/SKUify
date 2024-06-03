//
//  ExpensesUseCases.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import Domain

protocol ExpensesUseCases {
    func makeExpensesUseCase() -> Domain.ExpensesUseCase
    func makeExpensesCategoriesDataUseCase() -> Domain.ExpensesCategoriesDataUseCase
    func makeKeyboardUseCase() -> Domain.KeyboardUseCase
}
