//
//  SalesRefundsNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.02.2024.
//

import Foundation
import RxSwift
import Domain

final class SalesRefundsNetwork: SalesBaseNetwork, Domain.SalesRefundsNetwork {

    private let network: Network<SalesRefundsMainDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<SalesRefundsMainDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getSales(_ paginatedModel: SalesPaginatedModel) -> Observable<SalesRefundsMainDTO> {
        return network.request(
            makeUrl(from: paginatedModel),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeUrlEncodedContentTypeInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
}

