//
//  InventoryOrdersNetwork.swift
//  Domain
//
//  Created by George Churikov on 15.03.2024.
//

import Foundation
import RxSwift

public protocol InventoryOrdersNetwork {
    func getOrders(_ paginatedModel: InventoryPaginatedModel) -> Observable<InventoryOrdersResultsDTO>
}

