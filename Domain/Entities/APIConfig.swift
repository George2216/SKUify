//
//  APIConfig.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation

public struct APIConfig {
    public let apiEndpoint: String
    public let interceptorFactory: InterceptorFactory
    
    public init(
        apiEndpoint: String,
        interceptorFactory: InterceptorFactory
    ) {
        self.apiEndpoint = apiEndpoint
        self.interceptorFactory = interceptorFactory
    }
}
