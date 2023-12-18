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
        let endpoint = "https://skuify.com"

        self.realmUseCaseProvider = RealmPlatform.RealmUseCaseProvider()
        self.appEventsUseCaseProvider = AppEventsPlatform.AppEventsUseCaseProvider()
        
        let authDataUseCase = realmUseCaseProvider.makeAuthorizationDataUseCase()
        self.interceptorFactory = NetworkPlatform.InterceptorFactory(
            authorizationDataUseCase: authDataUseCase
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
        networkUseCaseProvider.makeLoginUseCase(realmUseCase: makeAutorizationDataUseCase())
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
}
