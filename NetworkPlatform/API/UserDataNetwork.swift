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
    
    private let network: Network<UserDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<UserDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    private func makeMedia(
        by key: String,
        imageData: Data?
    ) -> MultipartMediaModel {
        return MultipartMediaModel(
            key: key,
            filename: "\(UUID().uuidString).jpg",
            data: imageData,
            mimeType: "image/jpeg"
        )
    }
    
    func getUserData() -> Observable<UserDTO> {
        return network.request(
            "users/me/",
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeContentTypeJsonInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
    func updateUserData(data: Domain.UserRequestModel) -> Observable<UserDTO> {
        return network.request(
            "users/\(data.userId)/",
            method: .patch,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeAddMultipartFormDataInterceptor(
                        parameters: data.parameters,
                        media: [
                            makeMedia(
                                by: "avatar_image",
                                imageData: data.imageData
                            )
                        ]
                    ),
                    interceptorFactory.makeTokenToHeaderInterceptor(),
                    interceptorFactory.makeUserIdToURLPathInterceptor()
                ]
            )
        )
    }
    
    func updateCompanyInformation(data: Domain.CompanyInformationRequestModel) -> Observable<UserDTO> {
        return network.request(
            "users/\(data.userId)/",
            method: .patch,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeAddMultipartFormDataInterceptor(
                        parameters: data.parameters,
                        media: [
                            makeMedia(
                                by: "company_avatar_image",
                                imageData: data.imageData
                            )
                        ]
                    ),
                    interceptorFactory.makeTokenToHeaderInterceptor(),
                    interceptorFactory.makeUserIdToURLPathInterceptor()
                ]
            )
        )
    }
    
    func updateCurrency(_ data: CurrencyRequestModel) -> Observable<UserDTO> {
        return network.request(
            "users/\(data.userId)/",
            method: .patch,
            data: data.toData(),
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeTokenToHeaderInterceptor(),
                    interceptorFactory.makeUserIdToURLPathInterceptor(),
                    interceptorFactory.makeContentTypeJsonInterceptor()
                ]
            )
        )
    }
    
}
