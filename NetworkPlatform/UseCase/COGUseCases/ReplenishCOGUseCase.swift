//
//  ReplenishCOGUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 19.04.2024.
//

import Foundation
import Domain
import RxSwift

final class ReplenishCOGUseCase: Domain.ReplenishCOGUseCase {
    
    private let replenishCOGNetwork: Domain.ReplenishCOGNetwork

    init(replenishCOGNetwork: Domain.ReplenishCOGNetwork) {
        self.replenishCOGNetwork = replenishCOGNetwork
    }
    
    func saveReplenish(_ data: ReplenishCOGRequestModel) -> Observable<Void> {
        replenishCOGNetwork
            .saveReplenish(data)
            .mapToVoid()
    }
}
