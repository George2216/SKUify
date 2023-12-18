//
//  JSONContentTypeInterceptor.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation
import Domain
import Alamofire

final class UrlEncodedContentTypeInterceptor: Domain.Interceptor {
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
                    value: "application/x-www-form-urlencoded"
                )
            )
        
        completion(.success(modifiedRequest))
    }
    
}
