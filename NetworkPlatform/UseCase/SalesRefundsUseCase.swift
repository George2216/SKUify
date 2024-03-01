//
//  SalesRefundsUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.02.2024.
//

import Foundation
import Domain
import RxSwift

final class SalesRefundsUseCase: Domain.SalesRefundsUseCase {
    
    private let refundsNetwork: Domain.SalesRefundsNetwork
    private let ordersNetwork: Domain.SalesOrdersNetwork

    init(
        refundsNetwork: Domain.SalesRefundsNetwork,
        orderssNetwork: Domain.SalesOrdersNetwork

    ) {
        self.refundsNetwork = refundsNetwork
        self.ordersNetwork = orderssNetwork
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
