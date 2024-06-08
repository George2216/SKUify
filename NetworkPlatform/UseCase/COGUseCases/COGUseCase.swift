//
//  COGUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 16.04.2024.
//

import Foundation
import Domain
import RxSwift

final class COGUseCase: Domain.COGUseCase {
    
    private let salesCOGNetwork: Domain.COGSalesNetwork
    private let inventoryCOGNetwork: Domain.COGInventoryNetwork

    init(
        salesCOGNetwork: Domain.COGSalesNetwork,
        inventoryCOGNetwork: Domain.COGInventoryNetwork
    ) {
        self.salesCOGNetwork = salesCOGNetwork
        self.inventoryCOGNetwork = inventoryCOGNetwork
    }
    
    func updateSalesCOG(_ data: COGSalesRequestModel) -> Observable<Void> {
        salesCOGNetwork
            .updateCOG(data)
            .mapToVoid()
    }
   
    func updateInventoryCOG(_ data: COGInventoryRequestModel) -> Observable<Void> {
        inventoryCOGNetwork
            .updateCOG(data)
            .mapToVoid()
    }
    
    func deleteInventoryProduct(id: Int) -> Observable<Void> {
        inventoryCOGNetwork
            .deleteProductSettings(id: id)
            .mapToVoid()
    }
    
}
