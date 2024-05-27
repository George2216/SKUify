//
//  ReplenishCOGNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 19.04.2024.
//

import Foundation
import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class ReplenishCOGNetwork: Domain.ReplenishCOGNetwork {
    
    private let network: Network<OnlyIdDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<OnlyIdDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func saveReplenish(_ data: ReplenishCOGRequestModel) -> Observable<[OnlyIdDTO]> {
        return network.requestArray(
            "product/",
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
    
    func updateReplenish(_ data: ReplenishCOGRequestModel) {
        
    }
    
}
