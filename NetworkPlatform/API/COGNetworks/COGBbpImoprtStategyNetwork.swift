//
//  COGBbpImoprtStategyNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation
import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class COGBbpImoprtStategyNetwork: Domain.COGBbpImoprtStategyNetwork {
    
    private let network: Network<InventoryBuyBotImportsDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<InventoryBuyBotImportsDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func updateBBPImportStrategy(_ data: BbpImoprtStategyRequestModel) -> Observable<InventoryBuyBotImportsDTO> {
        network.request(
            "product/\(data.id)/update_bbp_import_strategy/",
            method: .post,
            data: data.toData(),
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeTokenToHeaderInterceptor(),
                    interceptorFactory.makeContentTypeJsonInterceptor()
                ]
            )
        )
    }
    
}
