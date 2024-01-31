//
//  UserDataNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 19.01.2024.
//

import Foundation
import RxSwift
import Domain

final class UserDataNetwork: Domain.UserDataNetwork {
    
    private let network: Network<UserMainDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<UserMainDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getUserData() -> Observable<UserMainDTO> {
        return network.request(
            "users/me/",
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeUrlEncodedContentTypeInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
    func updateUserData(data: Domain.UserRequestModel) -> Observable<UserMainDTO> {
        return network.request(
            "users/\(data.userId)/",
            method: .patch,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeAddMultipartFormDataInterceptor(
                        parameters: data.parameters,
                        media: [
                            MultipartMediaModel(
                                key: "avatar_image",
                                filename: "2995440.jpg",
                                data: data.imageData ,
                                mimeType: "image/jpeg"
                            )
                        ]
                    ),
                    interceptorFactory.makeTokenToHeaderInterceptor(),
                    interceptorFactory.makeUserIdToURLPathInterceptor()
                ]
            )
        )
    }
    
    
}
