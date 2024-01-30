//
//  LoginNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 08.12.2023.
//

import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class LoginNetwork: Domain.LoginNetwork {
    
    private let network: Network<LoginDTO>
    private let interceptorFactory: Domain.InterceptorFactory

    init(
        network: Network<LoginDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func login(
        email: String,
        password: String
    ) -> Observable<LoginDTO> {
        let parameters = [
            "username": email,
            "password": password
        ]
        return network.request(
            "users/token/",
            method: .post,
            parameters: parameters,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeUrlEncodedContentTypeInterceptor()
                ]
            )
        )
    }
    
}
