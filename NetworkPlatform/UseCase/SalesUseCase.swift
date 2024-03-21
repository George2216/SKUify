//
//  SalesRefundsUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.02.2024.
//

import Foundation
import Domain
import RxSwift

final class SalesUseCase: Domain.SalesUseCase {
    
    private let refundsNetwork: Domain.SalesRefundsNetwork
    private let ordersNetwork: Domain.SalesOrdersNetwork

    init(
        refundsNetwork: Domain.SalesRefundsNetwork,
        ordersNetwork: Domain.SalesOrdersNetwork

    ) {
        self.refundsNetwork = refundsNetwork
        self.ordersNetwork = ordersNetwork
    }
    
    func getRefundsSales(_ paginatedModel: SalesPaginatedModel) -> Observable<SalesRefundsResultsDTO> {
        refundsNetwork.getSales(paginatedModel)
            .map { $0.refunds }
    }
    
    func getOrdersSales(_ paginatedModel: SalesPaginatedModel) -> Observable<SalesOrdersResultsDTO> {
        ordersNetwork.getOrders(paginatedModel)
            .map { $0.orders }
    }
    
}
