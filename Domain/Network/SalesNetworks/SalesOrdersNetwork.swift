//
//  SalesOrdersNetwork.swift
//  Domain
//
//  Created by George Churikov on 12.02.2024.
//

import Foundation
import RxSwift

public protocol SalesOrdersNetwork {
    func getOrders(_ paginatedModel: SalesPaginatedModel) -> Observable<SalesOrdersMainDTO>
}

