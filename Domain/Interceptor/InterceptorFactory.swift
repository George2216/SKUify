//
//  InterceptorFactory.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation

public protocol InterceptorFactory {
    func makeTokenToHeaderInterceptor() -> Interceptor
    func makeUrlEncodedContentTypeInterceptor() -> Interceptor
    func makeUserIdToParametersInterceptor() -> Interceptor
    func makeUserIdToURLPathInterceptor() -> Interceptor
    func makeContentTypeJsonInterceptor() -> Interceptor
    func makeAddMultipartFormDataInterceptor(
        parameters: some Encodable,
        media: [MultipartMediaModel]
    ) -> Interceptor
    
}
