//
//  InventoryUseCase.swift
//  Domain
//
//  Created by George Churikov on 15.03.2024.
//

import Foundation
import RxSwift

public protocol InventoryUseCase {
    func getOrdersInventory(_ paginatedModel: InventoryPaginatedModel) -> Observable<InventoryOrdersResultsDTO>
    func getBuyBotImportsInventory(_ paginatedModel: InventoryPaginatedModel) -> Observable<InventoryBuyBotImportsResultsDTO>
}
