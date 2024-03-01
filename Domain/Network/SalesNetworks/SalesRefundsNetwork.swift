//
//  SalesRefundsNetwork.swift
//  Domain
//
//  Created by George Churikov on 06.02.2024.
//

import Foundation
import RxSwift

public protocol SalesRefundsNetwork {
    func getSales(_ paginatedModel: SalesPaginatedModel) -> Observable<SalesRefundsMainDTO>
}

