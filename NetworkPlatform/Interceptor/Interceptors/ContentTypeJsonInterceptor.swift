//
//  ContentTypeJsonInterceptor.swift
//  NetworkPlatform
//
//  Created by George Churikov on 27.03.2024.
//

import Foundation
import Domain
import Alamofire

final class ContentTypeJsonInterceptor: Domain.Interceptor {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var modifiedRequest = urlRequest
        modifiedRequest
            .headers
            .add(
                HTTPHeader(
                    name: "Content-Type",
                    value: "application/json"
                )
            )
        
        completion(.success(modifiedRequest))
    }
    
}
