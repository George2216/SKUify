//
//  RealmUseCaseProvider.swift
//  RealmPlatform
//
//  Created by George Churikov on 16.11.2023.
//

import Foundation
import Domain
import RealmSwift
import Realm

public final class RealmUseCaseProvider: Domain.RealmUseCaseProvider {
    
    private var configuration: Realm.Configuration
    
    public init() {
        configuration = Realm.Configuration()
    }
    
    public convenience init(configuration: Realm.Configuration) {
        self.init()
        self.configuration = configuration
    }
    
    public func makeLoginStateUseCase() -> Domain.LoginStateUseCase {
        let repository = Repository<LoginState>(configuration: configuration)
        return LoginStateUseCase(repository: repository)
    }
    
    public func makeAuthorizationDataUseCase() -> Domain.AuthorizationDataUseCase {
        let repository = Repository<AuthorizationData>(configuration: configuration)
        return AuthorizationDataUseCase(repository: repository)
    }

    public func makeTokensUseCase() -> Domain.TokensUseCase {
        let repository = Repository<Tokens>(configuration: configuration)
        return TokensUseCase(repository: repository)
    }
    
    public func makeUserIdUseCase() -> Domain.UserIdUseCase {
        let repository = Repository<UserId>(configuration: configuration)
        return UserIdUseCase(repository: repository)
    }
    
    public func makeMarketplacesUseCase() -> Domain.MarketplacesUseCase {
        let repository = Repository<MarketplaceDTO>(configuration: configuration)
        return MarketplacesUseCase(repository: repository)
    }
    
}
