//
//  NetworkUseCaseProvider.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation

public protocol NetworkUseCaseProvider {
    func makeLoginUseCase(
        autDataUseCase: AuthorizationDataWriteUseCase,
        tokensUseCase: TokensWriteUseCase,
        userIdUseCase: UserIdUseCase,
        marketplacesUseCase: MarketplacesWriteUseCase
    ) -> LoginUseCase
    func makeSubscriptionsUseCase() -> SubscriptionsUseCase
    func makeUpdatePasswordUseCase() -> UpdatePasswordUseCase
    func makeResetPasswordUseCase() -> Domain.ResetPasswordUseCase
    func makeChartsUseCase() -> ChartsUseCase
    func makeUserDataUseCase() -> UserDataUseCase
    func makeSalesUseCase() -> SalesUseCase
    func makeInventoryUseCase() -> InventoryUseCase
    func makeNoteInventoryUseCase() -> NoteUseCase
    func makeNoteSalesUseCase() -> NoteUseCase
    func makeBreakEvenPointUseCase() -> BreakEvenPointUseCase
    func makeCOGUseCase() -> COGUseCase
    func makeReplenishCOGUseCase() -> ReplenishCOGUseCase
    func makeCOGSInformationUseCase() -> COGSInformationUseCase
    func makeCOGBbpImoprtStategyUseCase() -> COGBbpImoprtStategyUseCase
    func makeCOGSettingsUseCase() -> COGSettingsUseCase
    func makeExpensesUseCase() -> ExpensesUseCase
    func makeExpensesCategoriesUseCase(categoriesDataUseCase: ExpensesCategoriesWriteDataUseCase) -> ExpensesCategoriesUseCase
}
