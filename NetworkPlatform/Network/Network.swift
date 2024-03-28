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
        parameters: [String: Any] = [:],
        interceptor: RequestInterceptor? = nil
    ) -> Observable<T> {
        return setupRequest(
            path,
            method: method,
            headers: headers,
            parameters: parameters,
            interceptor: interceptor
        )
        .decode(type: T.self, decoder: JSONDecoder())
    }
    
    func requestArray(
        _ path: String,
        method: HTTPMethod,
        headers: [String: String],
        parameters: [String: Any],
        interceptor: RequestInterceptor? = nil
    ) -> Observable<[T]> {
        return setupRequest(
            path,
            method: method,
            headers: headers,
            parameters: parameters,
            interceptor: interceptor
        )
        .decode(type: [T].self, decoder: JSONDecoder())
    }
    
    private func setupRequest(
        _ path: String,
        method: HTTPMethod,
        headers: [String: String] = [:],
        parameters: [String: Any] = [:],
        interceptor: RequestInterceptor? = nil
    ) -> Observable<Data> {
        
        let absolutePath = "\(endPoint)/\(path)"
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        return RxAlamofire
            .data(
                method,
                absolutePath,
                parameters: parameters,
                encoding: encoding,
                headers: HTTPHeaders(headers),
                interceptor: interceptor
            )
            .debug()
            .do(onNext: { data in
//                print(String(data: data, encoding: .utf8))
            })
            .observe(on: scheduler)
    }
}

