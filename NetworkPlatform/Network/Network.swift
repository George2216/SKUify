//
//  Network.swift
//  NetworkPlatform
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import RxAlamofire
import RxSwift
import Alamofire

final class Network<T: Decodable> {
    private let endPoint: String
    private let scheduler: ConcurrentDispatchQueueScheduler
    
    init(_ endPoint: String) {
        self.endPoint = endPoint
        self.scheduler = ConcurrentDispatchQueueScheduler(
            qos: DispatchQoS(
                qosClass: DispatchQoS.QoSClass.background,
                relativePriority: 1
            )
        )
    }
    
    func request(
        _ path: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        data: Data? = nil,
        interceptor: RequestInterceptor? = nil
    ) -> Observable<T> {
        return setupRequest(
            path,
            method: method,
            headers: headers,
            data: data,
            interceptor: interceptor
        )
        .flatMap(weak: self) { owner, data in
            owner.decode(data: data)
        }
    }
    
    func requestArray(
        _ path: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        data: Data? = nil,
        interceptor: RequestInterceptor? = nil
    ) -> Observable<[T]> {
        return setupRequest(
            path,
            method: method,
            headers: headers,
            data: data,
            interceptor: interceptor
        )
        .flatMap(weak: self) { owner, data in
            owner.decode(data: data)
        }
    }
 
    private func setupRequest(
        _ path: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        data: Data?,
        interceptor: RequestInterceptor? = nil
    ) -> Observable<Data> {
        
        let absolutePath = "\(endPoint)/\(path)"
        guard var request = try? URLRequest(
            url: absolutePath,
            method: method
        ) else {
            return .error(
                NSError(
                    domain: "",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Failary request"]
                )
            )
        }
        
        request.httpBody = data
        request.headers = headers.toHeaders()
        
        return RxAlamofire
            .requestData(
                request,
                interceptor: interceptor
            )
            .debug()
            .map { $0.1 }
            .do(onNext: { data in
                print(data.prettyPrintedJSONString as Any)
            })
            .observe(on: scheduler)
    }
    
}

// MARK: - Decoding helpers

extension Network {
    
    private func decode<E: Decodable>(data: Data) -> Observable<E> {
        do {
            let decoded = try JSONDecoder().decode(
                E.self,
                from: data
            )
            return Observable.just(decoded)
        } catch {
            return handleDecodingError(
                data: data,
                error: error
            )
        }
    }

    private func handleDecodingError<E>(
        data: Data,
        error: Error
    ) -> Observable<E> {
        if !data.isEmpty,
           let errorMessage = String(
            data: data,
            encoding: .utf8
           ) {
            let errorMessage = errorMessage.count > 1000 ?
            "Decoding failed" : errorMessage
            return Observable.error(
                NSError(
                    domain: "",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: errorMessage]
                )
            )
        } else {
            return Observable.error(error)
        }
    }
    
}
