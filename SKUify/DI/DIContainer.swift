//
//  DIContainer.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Domain
import RealmPlatform
import NetworkPlatform
import RxSwift
import AppEventsPlatform

class DIContainer: DIProtocol {
    
    // MARK: Providers
    
    private let networkUseCaseProvider: Domain.NetworkUseCaseProvider
    private let realmUseCaseProvider: Domain.RealmUseCaseProvider
    private let appEventsUseCaseProvider: Domain.AppEventsUseCaseProvider
    
    // MARK: Interceptor Factory

    private let interceptorFactory: Domain.InterceptorFactory

    // MARK: Initialization

    init() {
        let endpoint = "https://skuify.com/api/v1"

        self.realmUseCaseProvider = RealmPlatform.RealmUseCaseProvider()
        self.appEventsUseCaseProvider = AppEventsPlatform.AppEventsUseCaseProvider()
        
        let tokensUseCase = realmUseCaseProvider.makeTokensUseCase()
        let userIdUseCase = realmUseCaseProvider.makeUserIdUseCase()
        
        self.interceptorFactory = NetworkPlatform.InterceptorFactory(
            tokensUseCase: tokensUseCase,
            userIdUseCase: userIdUseCase
        )
        
        let config = Domain.APIConfig(
            apiEndpoint: endpoint,
            interceptorFactory: interceptorFactory
        )

        networkUseCaseProvider = NetworkPlatform.NetworkUseCaseProvider(
            networkProvider: NetworkProvider(
                config: config
            )
        )
    }
    
    // MARK: Make use cases

    // MARK: - Only network UseCases
    
    func makeSubscriptionsUseCase() -> Domain.SubscriptionsUseCase {
        networkUseCaseProvider.makeSubscriptionsUseCase()
    }
    
    func makeUpdatePasswordUseCase() -> Domain.UpdatePasswordUseCase {
        networkUseCaseProvider.makeUpdatePasswordUseCase()
    }
    
    func makeResetPasswordUseCase() -> Domain.ResetPasswordUseCase {
        networkUseCaseProvider.makeResetPasswordUseCase()
    }
    
    func makeChartsUseCase() -> Domain.ChartsUseCase {
        networkUseCaseProvider.makeChartsUseCase()
    }
    
    func makeUserDataUseCase() -> Domain.UserDataUseCase {
        networkUseCaseProvider.makeUserDataUseCase(makeCurrencyUseCase())
    }
    
    func makeSalesUseCase() -> Domain.SalesUseCase {
        networkUseCaseProvider.makeSalesUseCase()
    }
    
    func makeInventoryUseCase() -> Domain.InventoryUseCase {
        networkUseCaseProvider.makeInventoryUseCase()
    }
    
    func makeBreakEvenPointUseCase() -> Domain.BreakEvenPointUseCase {
        networkUseCaseProvider.makeBreakEvenPointUseCase()
    }
    
    func makeNotificationsUseCase() -> Domain.NotificationsUseCase {
        networkUseCaseProvider.makeNotificationsUseCase()
    }

    func makeCOGUseCase() -> Domain.COGUseCase {
        networkUseCaseProvider.makeCOGUseCase()
    }
    
    func makeReplenishCOGUseCase() -> Domain.ReplenishCOGUseCase {
        networkUseCaseProvider.makeReplenishCOGUseCase()
    }
    
    func makeCOGSInformationUseCase() -> Domain.COGSInformationUseCase {
        networkUseCaseProvider.makeCOGSInformationUseCase()
    }
    
    func makeCOGBbpImoprtStategyUseCase() -> Domain.COGBbpImoprtStategyUseCase {
        networkUseCaseProvider.makeCOGBbpImoprtStategyUseCase()
    }
    
    func makeCOGSettingsUseCase() -> Domain.COGSettingsUseCase {
        networkUseCaseProvider.makeCOGSettingsUseCase()
    }
    
    func makeExpensesUseCase() -> Domain.ExpensesUseCase {
        networkUseCaseProvider.makeExpensesUseCase()
    }
    
    // Note use case
    
    func makeNoteInventoryUseCase() -> Domain.NoteUseCase {
        return networkUseCaseProvider.makeNoteInventoryUseCase()
    }
    
    func makeNoteSalesUseCase() -> Domain.NoteUseCase {
        return networkUseCaseProvider.makeNoteSalesUseCase()
    }
    
    // MARK: - Realm UseCases

    func makeLoginStateUseCase() -> Domain.LoginStateUseCase {
        realmUseCaseProvider.makeLoginStateUseCase()
    }
    
    func makeAuthorizationDataUseCase() -> Domain.AuthorizationDataUseCase {
        realmUseCaseProvider.makeAuthorizationDataUseCase()
    }
    
    func makeCurrencyUseCase() -> Domain.CurrencyUseCase {
        realmUseCaseProvider.makeCurrencyUseCase()
    }
    
    func makeTokensUseCase() -> Domain.TokensUseCase {
        realmUseCaseProvider.makeTokensUseCase()
    }
    
    func makeUserIdUseCase() -> Domain.UserIdUseCase {
        realmUseCaseProvider.makeUserIdUseCase()
    }
    
    func makeMarketplacesUseCase() -> Domain.MarketplacesUseCase {
        realmUseCaseProvider.makeMarketplacesUseCase()
    }
    
    func makeExpensesCategoriesDataUseCase() -> Domain.ExpensesCategoriesDataUseCase {
        realmUseCaseProvider.makeExpensesCategoriesDataUseCase()
    }
  
    // MARK: - App Events UseCases

    func makeKeyboardUseCase() -> Domain.KeyboardUseCase {
        appEventsUseCaseProvider.makeKeyboardUseCase()
    }
    
    func makeAppVersionUseCase() -> Domain.AppVersionUseCase {
        appEventsUseCaseProvider.makeAppVersionUseCase()
    }

    // MARK: - Network use cases that use Realm
    
    func makeLoginUseCase() -> Domain.LoginUseCase {
        networkUseCaseProvider.makeLoginUseCase(
            autDataUseCase: makeAuthorizationDataUseCase(),
            tokensUseCase: makeTokensUseCase(),
            userIdUseCase: makeUserIdUseCase(),
            marketplacesUseCase: makeMarketplacesUseCase()
        )
    }
    
    func makeExpensesCategoriesUseCase() -> Domain.ExpensesCategoriesUseCase {
        networkUseCaseProvider.makeExpensesCategoriesUseCase(
            categoriesDataUseCase: makeExpensesCategoriesDataUseCase()
        )
    }
    
}
