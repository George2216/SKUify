//
//  NetworkUseCaseProvider.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation

public protocol NetworkUseCaseProvider {
     func makeLoginUseCase(realmUseCase: AuthorizationDataWriteUseCase) -> LoginUseCase
     func makeChartsUseCase() -> ChartsUseCase 

}
