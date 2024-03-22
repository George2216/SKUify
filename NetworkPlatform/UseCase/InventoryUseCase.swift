//
//  InventoryUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 15.03.2024.
//

import Foundation
import Domain
import RxSwift

final class InventoryUseCase: Domain.InventoryUseCase {
    
    private let buyBotImportsNetwork: Domain.InventoryBuyBotImportsNetwork
    private let ordersNetwork: Domain.InventoryOrdersNetwork

    init(
        buyBotImportsNetwork: Domain.InventoryBuyBotImportsNetwork,
        ordersNetwork: Domain.InventoryOrdersNetwork

    ) {
        self.buyBotImportsNetwork = buyBotImportsNetwork
        self.ordersNetwork = ordersNetwork
    }
    
    func getOrdersInventory(_ paginatedModel: InventoryPaginatedModel) -> Observable<InventoryOrdersResultsDTO> {
        ordersNetwork.getOrders(paginatedModel)
    }
    
    func getBuyBotImportsInventory(_ paginatedModel: InventoryPaginatedModel) -> Observable<InventoryBuyBotImportsResultsDTO> {
        buyBotImportsNetwork.getBuyBotImports(paginatedModel)
    }
    
}
