//
//  BreakEvenPointUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 11.04.2024.
//

import Foundation
import Domain
import RxSwift

final class BreakEvenPointUseCase: Domain.BreakEvenPointUseCase {
    
    private let salesBreakEvenPoinNetwork: Domain.BreakEvenPointNetwork
    private let inventoryBreakEvenPoinNetwork: Domain.BreakEvenPointNetwork

    init(
        salesBreakEvenPoinNetwork: Domain.BreakEvenPointNetwork,
        inventoryBreakEvenPoinNetwork: Domain.BreakEvenPointNetwork
    ) {
        self.salesBreakEvenPoinNetwork = salesBreakEvenPoinNetwork
        self.inventoryBreakEvenPoinNetwork = inventoryBreakEvenPoinNetwork
    }
    
    func getSalesBreakEvenPoint(_ data: COGBreakEvenRequestModel) -> Observable<BreakEvenPointDTO> {
        salesBreakEvenPoinNetwork
            .getBreakEvenPoint(data)
    }
    
    func getInventoryBreakEvenPoint(_ data: COGBreakEvenRequestModel) -> Observable<BreakEvenPointDTO> {
        inventoryBreakEvenPoinNetwork
            .getBreakEvenPoint(data)
    }
   
}
