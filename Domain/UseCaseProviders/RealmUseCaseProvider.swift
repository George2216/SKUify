//
//  RealmUseCaseProvider.swift
//  Domain
//
//  Created by George Churikov on 16.11.2023.
//

import Foundation

public protocol RealmUseCaseProvider {
    func makeLoginStateUseCase() -> Domain.LoginStateUseCase
    func makeAuthorizationDataUseCase() -> Domain.AuthorizationDataUseCase
}
