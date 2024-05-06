//
//  SalesBreakEvenPointNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 15.04.2024.
//

import Foundation
import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class SalesBreakEvenPointNetwork: Domain.BreakEvenPointNetwork {
    
    private let network: Network<BreakEvenPointDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<BreakEvenPointDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getBreakEvenPoint(_ id: Int) -> Observable<BreakEvenPointDTO> {
        return network.request(
            "break-point-even/\(id)/order_item/",
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeTokenToHeaderInterceptor(),
                    interceptorFactory.makeContentTypeJsonInterceptor()
                ]
            )
        )
    }
    
}
