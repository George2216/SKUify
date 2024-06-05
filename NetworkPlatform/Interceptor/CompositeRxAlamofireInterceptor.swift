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
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            var request = urlRequest
            var hasModified = false
            
            let dispatchGroup = DispatchGroup()
            let semaphore = DispatchSemaphore(value: 0)
            
            
            self.interceptors.forEach { interceptor in
                
                dispatchGroup.enter()
                
                interceptor.adapt(
                    request,
                    for: session
                ) { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case .success(let modifiedRequest):
                        self.addHeadersFromInterceptor(
                            request: &request,
                            modifiedRequest: modifiedRequest
                        )
                        
                        self.addBodyFromInterceptor(
                            request: &request,
                            modifiedRequest: modifiedRequest
                        )
                        
                        self.addQueryItemsFromInterceptor(
                            request: &request,
                            modifiedRequest: modifiedRequest
                        )
                        
                        hasModified = true
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    semaphore.signal()
                    dispatchGroup.leave()
                }
                semaphore.wait()
            }
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                guard let self else { return }
                
                print("Interceptors count: \(self.interceptors.count) \n")
                
                if let method = request.httpMethod,
                   let url = request.url {
                    
                    print("Request: \(method) \(url) \n")
                    
                    if let headers = request.allHTTPHeaderFields {
                        print("Headers: \(headers) \n")
                    }
                    if let body = request.httpBody {
                        print("Body: \(body.prettyPrintedJSONString as Any) \n")
                    }
                }
                
                print("\n\n\n")
                if hasModified {
                    completion(.success(request))
                } else {
                    completion(.success(urlRequest))
                }
            }
        }
    }
    
    private func addHeadersFromInterceptor(
        request: inout URLRequest,
        modifiedRequest: URLRequest
    ) {
        modifiedRequest.headers.forEach { header in
            request.headers.add(header)
        }
    }
    
    private func addBodyFromInterceptor(
        request: inout URLRequest,
        modifiedRequest: URLRequest
    ) {
        guard let data = modifiedRequest.httpBody else { return }
        if let body = request.httpBody {
            guard !body.contains(data) else { return }
        }
        if request.httpBody == nil {
            request.httpBody = data
        } else {
            request.httpBody?.append(data)
        }
    }
    
    private func addQueryItemsFromInterceptor(
        request: inout URLRequest,
        modifiedRequest: URLRequest
    ) {
        if let modifiedURL = modifiedRequest.url, let originalURL = request.url {
            let originalComponents = URLComponents(
                url: originalURL,
                resolvingAgainstBaseURL: false
            )
            let modifiedComponents = URLComponents(
                url: modifiedURL,
                resolvingAgainstBaseURL: false
            )
            
            // Filter out parameters that already exist in the original URL
            let newQueryItems = modifiedComponents?.queryItems?.filter { newItem in
                return !(originalComponents?.queryItems?.contains { $0.name == newItem.name } ?? false)
            }
            
            // Update the URL in the original request
            if let updatedURL = self.addQueryItems(originalComponents, newQueryItems) {
                request.url = updatedURL
            }
        }
    }
    // Function to add query items to URLComponents
    private func addQueryItems(
        _ components: URLComponents?,
        _ items: [URLQueryItem]?) -> URL?
    {
        guard var components = components, let items = items else {
            return nil
        }

        components.queryItems = (components.queryItems ?? []) + items
        return components.url
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
