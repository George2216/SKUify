//
//  LoginUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 08.12.2023.
//

import Foundation
import Domain
import RxSwift
import RxExtensions

final class LoginUseCase: Domain.LoginUseCase {
    
    private let network: Domain.LoginNetwork
    private let autDataUseCase: Domain.AuthorizationDataWriteUseCase
    private let tokensUseCase: Domain.TokensWriteUseCase
    private let userIdUseCase: Domain.UserIdUseCase
    private let marketplacesUseCase: Domain.MarketplacesWriteUseCase
    
    init(
        network: Domain.LoginNetwork,
        autDataUseCase: Domain.AuthorizationDataWriteUseCase,
        tokensUseCase: Domain.TokensWriteUseCase,
        userIdUseCase: Domain.UserIdUseCase,
        marketplacesUseCase: Domain.MarketplacesWriteUseCase
    ) {
        self.network = network
        self.autDataUseCase = autDataUseCase
        self.tokensUseCase = tokensUseCase
        self.userIdUseCase = userIdUseCase
        self.marketplacesUseCase = marketplacesUseCase
    }
    
    func login(
        email: String,
        password: String
    ) -> Observable<Void> {
        return network
            .login(
                email: email,
                password: password
            )
            .flatMapLatest(weak: self) { owner, data in
                return owner.autDataUseCase
                    .saveAuthorizationData(
                        data:
                            AuthorizationData(
                                email: email,
                                password: password
                            )
                    )
                    .flatMapLatest(weak: self) { owner, _ in
                        owner.tokensUseCase.saveTokens(
                            data: .init(
                                accessToken: data.access,
                                refreshToken: data.refresh
                            )
                        )
                    }
                    .flatMapLatest(weak: self) { owner, _ in
                        owner.userIdUseCase
                            .saveUserId(userId: data.user.id)
                    }
                    .flatMapLatest(weak: self) { owner, _ in
                        let marketplaces = data.user.amazon_settings.first?.marketplaces ?? []
                        return owner.marketplacesUseCase
                            .saveMarketplaces(marketplaces: marketplaces)
                    }
            }
    }
    
}
