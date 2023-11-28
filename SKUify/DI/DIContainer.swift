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
           
//    private let networkUseCaseProvider: Domain.NetworkUseCaseProvider
    private let realmUseCaseProvider: Domain.RealmUseCaseProvider
    private let appEventsUseCaseProvider: Domain.AppEventsUseCaseProvider
    
//    private let interceptorFactory: Domain.InterceptorFactory

    init() {
//        let endpoint = "https://api.profitprotectorpro.com/"
//        let xAuthorization = "9015-2EAB-0FD8-39DD-F30E"
//
        self.realmUseCaseProvider = RealmPlatform.RealmUseCaseProvider()
        self.appEventsUseCaseProvider = AppEventsPlatform.AppEventsUseCaseProvider()
        
        //        let authDataUseCase = realmUseCaseProvider.makeAuthorizationDataUseCase()
//
//        self.interceptorFactory = NetworkPlatform.InterceptorFactory(
//            xAuthorization: xAuthorization,
//            authorizationDataUseCase: authDataUseCase
//        )
//
//        let config = Domain.APIConfig(
//            apiEndpoint: endpoint,
//            interceptorFactory: interceptorFactory
//        )
//
//        networkUseCaseProvider = NetworkPlatform.NetworkUseCaseProvider(
//            networkProvider: NetworkProvider(
//                config: config
//            )
//        )
    }
    
    func makeLoginStateUseCase() -> Domain.LoginStateUseCase {
        realmUseCaseProvider.makeLoginStateUseCase()
    }
    
    func makeKeyboardUseCase() -> Domain.KeyboardUseCase {
        appEventsUseCaseProvider.makeKeyboardUseCase()
    }
   
}
