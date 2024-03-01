//
//  NetworkUseCaseProvider.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation

public protocol NetworkUseCaseProvider {
    func makeLoginUseCase(
        autDataUseCase: Domain.AuthorizationDataWriteUseCase,
        tokensUseCase: Domain.TokensWriteUseCase,
        userIdUseCase: Domain.UserIdUseCase,
        marketplacesUseCase: Domain.MarketplacesWriteUseCase
    ) -> LoginUseCase
    func makeChartsUseCase() -> ChartsUseCase
    func makeUserDataUseCase() -> UserDataUseCase
    func makeSalesRefundsUseCase() -> SalesRefundsUseCase
}
