//
//  COGSettingsNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation
import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class COGSettingsNetwork: Domain.COGSettingsNetwork {
    
    private let network: Network<OnlyIdDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<OnlyIdDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }

    func updateProductSettings(_ data: COGSettingsRequestModel) -> Observable<OnlyIdDTO> {
        network.request(
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
