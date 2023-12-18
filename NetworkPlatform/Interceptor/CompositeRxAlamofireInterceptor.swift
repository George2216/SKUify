//
//  CompositeRxAlamofireInterceptor.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.12.2023.
//

import Alamofire
import Domain

final class CompositeRxAlamofireInterceptor: RequestInterceptor {
    private let interceptors: [Domain.Interceptor]

    init(interceptors: [Domain.Interceptor]) {
        self.interceptors = interceptors
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {

        var request = urlRequest
        var hasModified = false
        
        let dispatchGroup = DispatchGroup()
        
        interceptors.forEach { interceptor in
            
            dispatchGroup.enter()
            interceptor.adapt(request, for: session) { result in
                switch result {
                case .success(let modifiedRequest):
                    
                    modifiedRequest.headers.forEach { header in
                        request.headers.add(header)
                    }
                    if request.httpBody != nil {
                        request.httpBody?.append(modifiedRequest.httpBody ?? Data())
                    } else {
                        request.httpBody = modifiedRequest.httpBody
                    }
                    
                    hasModified = true
                    dispatchGroup.leave()
                    
                case .failure(let error):
                    completion(.failure(error))
                    dispatchGroup.leave()
                    
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if hasModified {
                completion(.success(request))
            } else {
                completion(.success(urlRequest))
            }
        }
    }
    
     func retry(
            _ request: Request,
            for session: Session,
            dueTo error: Error,
            completion: @escaping (RetryResult) -> Void
        ) {
            var retryResult: RetryResult?
            let semaphore = DispatchSemaphore(value: 1)

            let dispatchGroup = DispatchGroup()
            for interceptor in interceptors {
                dispatchGroup.enter()
                interceptor.retry(request, for: session, dueTo: error) { result in
                    semaphore.wait()
                    switch result {
                    case .doNotRetry:
                        break
                    case .retryWithDelay(let timeInterval):
                        retryResult = .retryWithDelay(timeInterval)
                    case .doNotRetryWithError(let error):
                        if retryResult == nil {
                            retryResult = .doNotRetryWithError(error)
                        }
                    case .retry:
                        retryResult = .retry
                    }
                    semaphore.signal()
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(retryResult ?? .doNotRetry)
            }
        }
    
}
