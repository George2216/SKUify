//
//  SubscriptionsUseCase.swift
//  Domain
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import RxSwift

public protocol SubscriptionsUseCase {
    func getSubscriptions() -> Observable<[SubscriptionDTO]>
}
