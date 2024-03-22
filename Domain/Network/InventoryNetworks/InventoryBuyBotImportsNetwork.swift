//
//  InventoryBuyBotImportsNetwork.swift
//  Domain
//
//  Created by George Churikov on 20.03.2024.
//

import Foundation
import RxSwift

public protocol InventoryBuyBotImportsNetwork {
    func getBuyBotImports(_ paginatedModel: InventoryPaginatedModel) -> Observable<InventoryBuyBotImportsResultsDTO>
}
