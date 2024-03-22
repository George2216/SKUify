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
    func makeChartsUseCase() -> ChartsUseCase
    func makeUserDataUseCase() -> UserDataUseCase
    func makeSalesUseCase() -> SalesUseCase
    func makeInventoryUseCase() -> InventoryUseCase
}
