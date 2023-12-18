//
//  InterceptorFactory.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation
import Domain

public final class InterceptorFactory: Domain.InterceptorFactory {

    private let authorizationDataUseCase: Domain.AuthorizationDataReadUseCase

    public init(authorizationDataUseCase: Domain.AuthorizationDataReadUseCase) {
        self.authorizationDataUseCase = authorizationDataUseCase
    }
    
    public func makeTokenToHeaderInterceptor() -> Domain.Interceptor {
        return TokenToHeaderInterceptor(authorizationDataReadUseCase: authorizationDataUseCase)
    }
    
    public func makeUrlEncodedContentTypeInterceptor() -> Domain.Interceptor {
        return UrlEncodedContentTypeInterceptor()
    }
    
}
