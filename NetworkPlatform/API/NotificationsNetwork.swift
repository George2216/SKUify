//
//  NotificationsNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 26.06.2024.
//

import Foundation
import Domain
import RxSwift

final class NotificationsNetwork: Domain.NotificationsNetwork  {
    
    private let network: Network<NotificationsDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<NotificationsDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getNotifications(_ model: NotificationsPaginatedModel) -> Observable<NotificationsDTO> {
        return network.request(
            "notifications/?limit=\(model.limit)&offset=\(model.offset ?? 0)&/",
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeTokenToHeaderInterceptor(),
                    interceptorFactory.makeContentTypeJsonInterceptor()
                ]
            )
        )
    }
    
}
