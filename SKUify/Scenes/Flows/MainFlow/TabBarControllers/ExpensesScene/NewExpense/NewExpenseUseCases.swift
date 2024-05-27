//
//  NewExpenseUseCases.swift
//  SKUify
//
//  Created by George Churikov on 23.05.2024.
//

import Foundation
import Domain

protocol NewExpenseUseCases {
    func makeExpensesCategoriesDataUseCase() -> Domain.ExpensesCategoriesDataUseCase
}
