//
//  NetworkUseCaseProvider.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation
import Domain

// Network use case provider for creating network-related use cases, implementing the Domain.NetworkUseCaseProvider protocol
public final class NetworkUseCaseProvider: Domain.NetworkUseCaseProvider {
    
    // MARK: Properties
    
    private let networkProvider: Domain.NetworkProvider
    
    // MARK: Initialization
    
    public init(networkProvider: Domain.NetworkProvider) {
        self.networkProvider = networkProvider
    }
        
    // MARK: Make Use Cases
    
    public func makeLoginUseCase(
        autDataUseCase: Domain.AuthorizationDataWriteUseCase,
        tokensUseCase: Domain.TokensWriteUseCase,
        userIdUseCase: Domain.UserIdUseCase,
        marketplacesUseCase: Domain.MarketplacesWriteUseCase
    ) -> Domain.LoginUseCase {
        return LoginUseCase(
            network: networkProvider.makeLoginNetwork(),
            autDataUseCase: autDataUseCase,
            tokensUseCase: tokensUseCase,
            userIdUseCase: userIdUseCase,
            marketplacesUseCase: marketplacesUseCase
        )
    }
    
    public func makeSubscriptionsUseCase() -> Domain.SubscriptionsUseCase {
        return SubscriptionsUseCase(network: networkProvider.makeSubscriptionsNetwork())
    }
    
    public func makeUpdatePasswordUseCase() -> Domain.UpdatePasswordUseCase {
        return UpdatePasswordUseCase(network: networkProvider.makeUpdatePasswordNetwork())
    }
    
    public func makeResetPasswordUseCase() -> Domain.ResetPasswordUseCase {
        return ResetPasswordUseCase(network: networkProvider.makeResetPasswordNetwork())
    }
     
    public func makeChartsUseCase() -> Domain.ChartsUseCase {
        return ChartsUseCase(network: networkProvider.makeChartsNetwork())
    }
    
    public func makeUserDataUseCase() -> Domain.UserDataUseCase {
        return UserDataUseCase(network: networkProvider.makeUserDataNetwork())
    }
    
    public func makeBreakEvenPointUseCase() -> Domain.BreakEvenPointUseCase {
        return BreakEvenPointUseCase(
            salesBreakEvenPoinNetwork: networkProvider.makeSalesBreakEvenPointNetwork(),
            inventoryBreakEvenPoinNetwork: networkProvider.makeInventoryBreakEvenPointNetwork()
        )
    }
    
    public func makeCOGSInformationUseCase() -> Domain.COGSInformationUseCase {
        return COGSInformationUseCase(informationCOGSNetwork: networkProvider.makeCOGSInformationNetwork())
    }
    
    // MARK: - I'm not sure that passing two Networks to UseCase is a very clean approach, but it seems to me that it will be more readable

    public func makeSalesUseCase() -> Domain.SalesUseCase {
        return SalesUseCase(
            refundsNetwork: networkProvider.makeSalesRefundsNetwork(),
            ordersNetwork: networkProvider.makeSalesOrdersNetwork()
        )
    }
    
    public func makeInventoryUseCase() -> Domain.InventoryUseCase {
        return InventoryUseCase(
            buyBotImportsNetwork: networkProvider.makeInventoryBuyBotImportsNetwork(),
            ordersNetwork: networkProvider.makeInventoryOrdersNetwork()
        )
    }
    
    public func makeCOGUseCase() -> Domain.COGUseCase {
        return COGUseCase(
            salesCOGNetwork: networkProvider.makeCOGSalesNetwork(),
            inventoryCOGNetwork: networkProvider.makeCOGInventoryNetwork()
        )
    }
    
    public func makeReplenishCOGUseCase() -> Domain.ReplenishCOGUseCase {
        return ReplenishCOGUseCase(replenishCOGNetwork: networkProvider.makeReplenishCOGNetwork())
    }
    
    public func makeCOGBbpImoprtStategyUseCase() -> Domain.COGBbpImoprtStategyUseCase {
        return COGBbpImoprtStategyUseCase(imoprtStategyNetwork: networkProvider.makeCOGBbpImoprtStategyNetwork())
    }
    
    public func makeCOGSettingsUseCase() -> Domain.COGSettingsUseCase {
        return COGSettingsUseCase(settingsNetwork: networkProvider.makeCOGSettingsNetwork())
    }
    
    // MARK: - Expenses
    
    public func makeExpensesUseCase() -> Domain.ExpensesUseCase {
        return ExpensesUseCase(
            expensesNetwork: networkProvider.makeExpensesNetwork(),
            updateExpensesNetwork: networkProvider.makeUpdateExpensesNetwork()
        )
    }
    
    public func makeExpensesCategoriesUseCase(categoriesDataUseCase: Domain.ExpensesCategoriesWriteDataUseCase) -> Domain.ExpensesCategoriesUseCase {
        return ExpensesCategoriesUseCase(
            expensesCategoriesNetwork: networkProvider.makeExpensesCategoriesNetwork(),
            expensesCategoriesDataUseCase: categoriesDataUseCase
        )
    }
    
    // MARK: - Note
    
    public func makeNoteInventoryUseCase() -> Domain.NoteUseCase {
        return NoteInventoryUseCase(network: networkProvider.makeNoteInventoryNetwork())
    }
    
    public func makeNoteSalesUseCase() -> Domain.NoteUseCase {
        return NoteSalesUseCase(network: networkProvider.makeNoteSalesNetwork())
    }
    
}
