//
//  InterceptorFactory.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation
import Domain

public final class InterceptorFactory: Domain.InterceptorFactory {

    private let tokensUseCase: Domain.TokensReadUseCase
    private let userIdUseCase: Domain.UserIdReadUseCase
    
    public init(
        tokensUseCase: Domain.TokensReadUseCase,
        userIdUseCase: Domain.UserIdReadUseCase
    ) {
        self.tokensUseCase = tokensUseCase
        self.userIdUseCase = userIdUseCase
    }
    
    public func makeTokenToHeaderInterceptor() -> Domain.Interceptor {
        return TokenToHeaderInterceptor(tokensReadUseCase: tokensUseCase)
    }
    
    public func makeUrlEncodedContentTypeInterceptor() -> Domain.Interceptor {
        return UrlEncodedContentTypeInterceptor()
    }
    
    public func makeUserIdToParametersInterceptor() -> Domain.Interceptor {
        return UserIdToParametersInterceptor(userIdReadUseCase: userIdUseCase)
    }
    
    public func makeUserIdToURLPathInterceptor() -> Domain.Interceptor {
        return UserIdToURLPathInterceptor(userIdReadUseCase: userIdUseCase)
    }
        
    public func makeAddMultipartFormDataInterceptor(
        parameters: some Encodable,
        media: [MultipartMediaModel]
    ) -> Domain.Interceptor {
        return AddMultipartFormDataInterceptor(
            parameters: parameters,
            media: media
        )
    }
    
}
