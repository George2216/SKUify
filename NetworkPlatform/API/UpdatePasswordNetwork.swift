//
//  UpdatePasswordNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 06.06.2024.
//

import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class UpdatePasswordNetwork: Domain.UpdatePasswordNetwork {
    
    private let network: Network<StatusDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<StatusDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func updatePassword(_ data: UpdatePasswordRequestModel) -> Observable<StatusDTO> {
        return network.request(
            "users/change-password/",
            method: .put,
            data: data.toData(),
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeContentTypeJsonInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
}
