//
//  Interceptor.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation
import Alamofire

public protocol Interceptor {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    )
}

public extension Interceptor {
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        completion(.doNotRetry)
    }
}
