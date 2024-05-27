//
//  UpdateExpensesNetwork.swift
//  NetworkPlatform
//
//  Created by George Churikov on 21.05.2024.
//

import Foundation
import Domain
import RxSwift

final class UpdateExpensesNetwork: Domain.UpdateExpensesNetwork {
    private let network: Network<ExpenseDTO>
    private let interceptorFactory: Domain.InterceptorFactory
    
    init(
        network: Network<ExpenseDTO>,
        interceptorFactory: Domain.InterceptorFactory
    ) {
        self.network = network
        self.interceptorFactory = interceptorFactory
    }
    
    func updateExpenses(_ expenses: [ExpenseDTO]) -> Observable<[ExpenseDTO]> {
        return network.requestArray(
            "expense/",
            method: .post,
            data: expenses.toData(),
            interceptor: CompositeRxAlamofireInterceptor(
                interceptors: [
                    interceptorFactory.makeContentTypeJsonInterceptor(),
                    interceptorFactory.makeTokenToHeaderInterceptor()
                ]
            )
        )
    }
    
}

