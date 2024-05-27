//
//  RealmUseCaseProvider.swift
//  Domain
//
//  Created by George Churikov on 16.11.2023.
//

import Foundation

public protocol RealmUseCaseProvider {
    func makeLoginStateUseCase() -> LoginStateUseCase
    func makeAuthorizationDataUseCase() -> AuthorizationDataUseCase
    func makeTokensUseCase() -> TokensUseCase
    func makeUserIdUseCase() -> UserIdUseCase
    func makeMarketplacesUseCase() -> MarketplacesUseCase
    func makeExpensesCategoriesDataUseCase() -> ExpensesCategoriesDataUseCase
}
