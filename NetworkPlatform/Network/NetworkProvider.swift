//
//  NetworkProvider.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.12.2023.
//

import Domain

// Network provider for handling network requests, implementing the Domain.NetworkProvider protocol
final public class NetworkProvider: Domain.NetworkProvider {
    
    // MARK: Properties
    
    private let apiEndpoint: String
    private let interceptorFactory: Domain.InterceptorFactory
    
    // MARK: Initialization
    
    public init(config: Domain.APIConfig) {
        self.apiEndpoint = config.apiEndpoint
        self.interceptorFactory = config.interceptorFactory
    }
    
    // Creates an instance of the network client
    private func makeNetwork<T>(_ type: T.Type) -> Network<T> {
        return Network(apiEndpoint)
    }
    
    // MARK: Make network
    
    public func makeLoginNetwork() -> Domain.LoginNetwork {
        return LoginNetwork(
            network: makeNetwork(LoginDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeSubscriptionsNetwork() -> Domain.SubscriptionsNetwork {
        return SubscriptionsNetwork(
            network: makeNetwork(SubscriptionDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeUpdatePasswordNetwork() -> Domain.UpdatePasswordNetwork {
        return UpdatePasswordNetwork(
            network: makeNetwork(StatusDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeChartsNetwork() -> Domain.ChartsNetwork {
        return ChartsNetwork(
            network: makeNetwork(ChartMainDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeUserDataNetwork() -> Domain.UserDataNetwork {
        return UserDataNetwork(
            network: makeNetwork(UserMainDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeSalesBreakEvenPointNetwork() -> Domain.BreakEvenPointNetwork {
        return SalesBreakEvenPointNetwork(
            network: makeNetwork(BreakEvenPointDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeInventoryBreakEvenPointNetwork() -> Domain.BreakEvenPointNetwork {
        return InventoryBreakEvenPointNetwork(
            network: makeNetwork(BreakEvenPointDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    // MARK: - Sales
    
    public func makeSalesRefundsNetwork() -> Domain.SalesRefundsNetwork {
        return SalesRefundsNetwork(
            network: makeNetwork(SalesRefundsMainDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeSalesOrdersNetwork() -> Domain.SalesOrdersNetwork {
        return SalesOrdersNetwork(
            network: makeNetwork(SalesOrdersMainDTO.self),
            interceptorFactory: interceptorFactory
        )
    }

    public func makeCOGSalesNetwork() -> Domain.COGSalesNetwork {
        return COGSalesNetwork(
            network: makeNetwork(OnlyIdDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeCOGSInformationNetwork() -> Domain.COGSInformationNetwork {
        return COGSInformationNetwork(
            network:makeNetwork(CostOfGoodsSettingsMainDTO.self), 
            interceptorFactory: interceptorFactory
        )
    }
    
    // MARK: - Inventory
    
    public func makeInventoryOrdersNetwork() -> Domain.InventoryOrdersNetwork {
        return InventoryOrdersNetwork(
            network: makeNetwork(InventoryOrdersResultsDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeInventoryBuyBotImportsNetwork() -> Domain.InventoryBuyBotImportsNetwork {
        return InventoryBuyBotImportsNetwork(
            network: makeNetwork(InventoryBuyBotImportsResultsDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeCOGInventoryNetwork() -> Domain.COGInventoryNetwork {
        return COGInventoryNetwork(
            network: makeNetwork(OnlyIdDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeReplenishCOGNetwork() -> Domain.ReplenishCOGNetwork {
        return ReplenishCOGNetwork(
            network: makeNetwork(OnlyIdDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeCOGBbpImoprtStategyNetwork() -> Domain.COGBbpImoprtStategyNetwork {
        return COGBbpImoprtStategyNetwork(
            network: makeNetwork(InventoryBuyBotImportsDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeCOGSettingsNetwork() -> Domain.COGSettingsNetwork {
        return COGSettingsNetwork(
            network: makeNetwork(OnlyIdDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    // MARK: - Expenses
    
    public func makeExpensesNetwork() -> Domain.ExpensesNetwork {
        return ExpensesNetwork(
            network: makeNetwork(ExpensesResultsDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeUpdateExpensesNetwork() -> Domain.UpdateExpensesNetwork {
        return UpdateExpensesNetwork(
            network: makeNetwork(ExpenseDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeExpensesCategoriesNetwork() -> Domain.ExpensesCategoriesNetwork {
        return ExpensesCategoriesNetwork(
            network: makeNetwork(ExpensesCategoryDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    // MARK: - Note
    
    public func makeNoteInventoryNetwork() -> Domain.NoteNetwork {
        return NoteInventoryNetwork(
            network: makeNetwork(NoteDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeNoteSalesNetwork() -> Domain.NoteNetwork {
        return NoteSalesNetwork(
            network: makeNetwork(NoteDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
}
