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

    func makeLoginUseCase() -> Domain.LoginUseCase {
        networkUseCaseProvider.makeLoginUseCase(
            autDataUseCase: makeAutorizationDataUseCase(),
            tokensUseCase: makeTokensUseCase(),
            userIdUseCase: makeUserIdUseCase(),
            marketplacesUseCase: makeMarketplacesUseCase()
        )
    }
    
    func makeLoginStateUseCase() -> Domain.LoginStateUseCase {
        realmUseCaseProvider.makeLoginStateUseCase()
    }
    
    func makeKeyboardUseCase() -> Domain.KeyboardUseCase {
        appEventsUseCaseProvider.makeKeyboardUseCase()
    }
    
    func makeAppVersionUseCase() -> Domain.AppVersionUseCase {
        appEventsUseCaseProvider.makeAppVersionUseCase()
    }
    
    func makeAutorizationDataUseCase() -> Domain.AuthorizationDataUseCase {
        realmUseCaseProvider.makeAuthorizationDataUseCase()
    }
    
    func makeChartsUseCase() -> Domain.ChartsUseCase {
        networkUseCaseProvider.makeChartsUseCase()
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

    func makeUserDataUseCase() -> Domain.UserDataUseCase {
        networkUseCaseProvider.makeUserDataUseCase()
    }
    
    func makeSalesRefundsUseCase() -> Domain.SalesRefundsUseCase {
        networkUseCaseProvider.makeSalesRefundsUseCase()
    }
    
}
