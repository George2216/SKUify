//
//  InventoryBuyBotImportsNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 20.03.2024.
//

import Foundation
import Domain
import RxSwift

final class InventoryBuyBotImportsNetwork: InventoryBaseNetwork, Domain.InventoryBuyBotImportsNetwork {

    private let network: Network<InventoryBuyBotImportsResultsDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<InventoryBuyBotImportsResultsDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getBuyBotImports(_ paginatedModel: InventoryPaginatedModel) -> Observable<InventoryBuyBotImportsResultsDTO> {
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
