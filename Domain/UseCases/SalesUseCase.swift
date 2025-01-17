//
//  SalesUseCase.swift
//  Domain
//
//  Created by George Churikov on 07.02.2024.
//

import Foundation
import RxSwift

public protocol SalesUseCase {
    func getRefundsSales(_ paginatedModel: SalesPaginatedModel) -> Observable<SalesRefundsResultsDTO>
    func getOrdersSales(_ paginatedModel: SalesPaginatedModel) -> Observable<SalesOrdersResultsDTO>
}
