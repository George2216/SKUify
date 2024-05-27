//
//  COGInventoryNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 15.04.2024.
//

import Foundation
import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class COGInventoryNetwork: Domain.COGInventoryNetwork {
    
    private let network: Network<OnlyIdDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<OnlyIdDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func updateCOG(_ data: Domain.COGInventoryRequestModel) -> Observable<OnlyIdDTO> {
        return network.request(
            "product/\(data.id)/",
            method: .patch,
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
