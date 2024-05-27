//
//  ExpensesNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation
import Domain
import RxSwift

final class ExpensesNetwork: Domain.ExpensesNetwork {
    private let network: Network<ExpensesResultsDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<ExpensesResultsDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getExpensesNetwork(_ paginatedModel: ExpensesPaginatedModel) -> Observable<ExpensesResultsDTO> {
        return network.request(
            makeUrl(from: paginatedModel),
            method: .get,
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeContentTypeJsonInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
}

extension ExpensesNetwork {
    
    private func makeUrl(from paginatedModel: ExpensesPaginatedModel) -> String {
        "expense/?limit=\(paginatedModel.limit)&offset=\(paginatedModel.offset ?? 0)"
    }
    
}
