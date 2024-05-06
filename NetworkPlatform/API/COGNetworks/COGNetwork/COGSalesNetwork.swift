//
//  COGSalesNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 15.04.2024.
//

import Foundation
import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class COGSalesNetwork: Domain.COGSalesNetwork {
    
    private let network: Network<OnlyIdDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<OnlyIdDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func updateCOG(_ data: Domain.COGSalesRequestModel) -> Observable<OnlyIdDTO> {
        return network.request(
            "order-item/\(data.id)/",
            method: .patch,
            parameters: data.toDictionary(),
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeTokenToHeaderInterceptor(),
                    interceptorFactory.makeContentTypeJsonInterceptor()
                ]
            )
        )
    }
    
}
