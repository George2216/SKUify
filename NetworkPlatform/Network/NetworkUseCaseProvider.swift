//
//  NetworkUseCaseProvider.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation
import Domain

// Network use case provider for creating network-related use cases, implementing the Domain.NetworkUseCaseProvider protocol
public final class NetworkUseCaseProvider: Domain.NetworkUseCaseProvider {
    
    // MARK: Properties
    
    private let networkProvider: Domain.NetworkProvider
    
    // MARK: Initialization
    
    public init(networkProvider: Domain.NetworkProvider) {
        self.networkProvider = networkProvider
    }
        
    // MARK: Make Use Cases
    
    public func makeLoginUseCase(
        realmUseCase: Domain.AuthorizationDataWriteUseCase
    ) -> Domain.LoginUseCase {
        return LoginUseCase(
            network: networkProvider.makeLoginNetwork(),
            realmUseCase: realmUseCase
        )
    }
}