//
//  ExpensesCategoriesNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation
import Domain
import RxSwift

final class ExpensesCategoriesNetwork: Domain.ExpensesCategoriesNetwork {
    private let network: Network<ExpensesCategoryDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<ExpensesCategoryDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func getCategories() -> Observable<[ExpensesCategoryDTO]> {
        return network.requestArray(
            "expense_categories/",
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

