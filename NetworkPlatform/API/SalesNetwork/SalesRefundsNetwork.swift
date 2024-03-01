//
//  SalesRefundsNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.02.2024.
//

import Foundation
import RxSwift
import Domain

final class SalesRefundsNetwork: Domain.SalesRefundsNetwork {

    private let network: Network<SalesRefundsMainDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<SalesRefundsMainDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getSales(_ paginatedModel: SalesPaginatedModel) -> Observable<SalesRefundsMainDTO> {
        return network.request(
            makeUrl(from: paginatedModel),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
    private func makeUrl(from paginatedModel: SalesPaginatedModel) -> String {
        var urlString = "sales/?period=all&page_name=sales&salesOnly=true&autoRefresh=true"
            let parameters = paginatedModel.toDictionary()
            .toURLParameters()
        urlString += parameters
        return urlString
    }
    
}

