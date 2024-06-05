//
//  SubscriptionsUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import Domain
import RxSwift
import RxExtensions

final class SubscriptionsUseCase: Domain.SubscriptionsUseCase {
    
    private let network: Domain.SubscriptionsNetwork

    init(network: Domain.SubscriptionsNetwork) {
        self.network = network
    }
    
    func getSubscriptions() -> Observable<[SubscriptionDTO]> {
        network
            .getSubscribtions()
    }
    
}
