//
//  COGSInformationNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 29.04.2024.
//

import Foundation
import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class COGSInformationNetwork: Domain.COGSInformationNetwork {
    
    private let network: Network<CostOfGoodsSettingsMainDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<CostOfGoodsSettingsMainDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getCOGSInformation() -> Observable<[CostOfGoodsSettingsMainDTO]> {
        network.requestArray(
            "settings/",
            method: .get, interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeTokenToHeaderInterceptor(),
                    interceptorFactory.makeContentTypeJsonInterceptor()
                ]
            )
        )
    }

    
}
