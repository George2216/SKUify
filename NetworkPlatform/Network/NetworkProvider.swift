//
//  NetworkProvider.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.12.2023.
//

import Domain

// Network provider for handling network requests, implementing the Domain.NetworkProvider protocol
final public class NetworkProvider: Domain.NetworkProvider {
    
    // MARK: Properties
    
    private let apiEndpoint: String
    private let interceptorFactory: Domain.InterceptorFactory
    
    // MARK: Initialization
    
    public init(config: Domain.APIConfig) {
        self.apiEndpoint = config.apiEndpoint
        self.interceptorFactory = config.interceptorFactory
    }
    
    // Creates an instance of the network client
    private func makeNetwork<T>(_ type: T.Type) -> Network<T> {
        return Network(apiEndpoint)
    }
    
    // MARK: Make network
    
    public func makeLoginNetwork() -> Domain.LoginNetwork {
        return LoginNetwork(
            network: makeNetwork(LoginDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
    
    public func makeChartsNetwork() -> Domain.ChartsNetwork {
        return ChartsNetwork(
            network: makeNetwork(ChartMainDTO.self),
            interceptorFactory: interceptorFactory
        )
    }
}
