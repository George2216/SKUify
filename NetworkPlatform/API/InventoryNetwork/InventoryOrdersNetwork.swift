//
//  InventoryOrdersNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 15.03.2024.
//

import Foundation
import Domain
import RxSwift

final class InventoryOrdersNetwork: InventoryBaseNetwork, Domain.InventoryOrdersNetwork {
    private let network: Network<InventoryOrdersResultsDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<InventoryOrdersResultsDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getOrders(_ paginatedModel: InventoryPaginatedModel) -> Observable<InventoryOrdersResultsDTO> {
        return network.request(
            makeUrl(from: paginatedModel),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeContentTypeJsonInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
}
