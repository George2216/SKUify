//
//  SubscriptionUseCase.swift
//  SKUify
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import Domain

protocol SubscriptionUseCase {
    func makeSubscriptionsUseCase() -> Domain.SubscriptionsUseCase
}
