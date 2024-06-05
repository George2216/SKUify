//
//  SubscriptionsNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 04.06.2024.
//

import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class SubscriptionsNetwork: Domain.SubscriptionsNetwork {
    
    private let network: Network<SubscriptionDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<SubscriptionDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getSubscribtions() -> Observable<[SubscriptionDTO]> {
        return network.requestArray(
            "zoho_integration/active-list-plans/?period=months&location=UK&/",
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeContentTypeJsonInterceptor()
                ]
            )
        )
    }
    
}
