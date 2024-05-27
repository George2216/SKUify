//
//  NoteSalesNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 27.03.2024.
//

import Foundation
import Domain
import RxSwift
import Alamofire
import RxAlamofire

final class NoteSalesNetwork: Domain.NoteNetwork {
    
    private let network: Network<NoteDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<NoteDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func updateNote(_ data: NoteRequestModel) -> Observable<NoteDTO> {
        return network.request(
            "order-item/\(data.id)/update_note/",
            method: .post,
            data: NoteDTO(note: data.note).toData(),
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeContentTypeJsonInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
}
