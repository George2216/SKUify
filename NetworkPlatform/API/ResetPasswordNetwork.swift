//
//  ResetPasswordNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 10.06.2024.
//

import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class ResetPasswordNetwork: Domain.ResetPasswordNetwork {
    
    private let network: Network<StatusDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<StatusDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func resetPassword(_ data: ResetPasswordRequestModel) -> Observable<StatusDTO> {
        return network.request(
            "password_reset/",
            method: .post,
            data: data.toData(),
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeContentTypeJsonInterceptor()
                ]
            )
        )
    }
    
}
