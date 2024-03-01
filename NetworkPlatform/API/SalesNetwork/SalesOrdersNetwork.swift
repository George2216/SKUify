//
//  SalesOrdersNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 12.02.2024.
//

import Foundation
import Domain
import RxSwift

final class SalesOrdersNetwork: Domain.SalesOrdersNetwork {

    private let network: Network<SalesOrdersMainDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<SalesOrdersMainDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getOrders(_ paginatedModel: SalesPaginatedModel) -> Observable<SalesOrdersMainDTO> {
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

