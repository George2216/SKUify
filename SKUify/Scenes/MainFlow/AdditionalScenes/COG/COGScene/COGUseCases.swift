//
//  COGUseCases.swift
//  SKUify
//
//  Created by George Churikov on 29.03.2024.
//

import Foundation
import Domain

protocol COGUseCases {
    func makeBreakEvenPointUseCase() -> Domain.BreakEvenPointUseCase
    func makeCOGUseCase() -> Domain.COGUseCase
    func makeReplenishCOGUseCase() -> Domain.ReplenishCOGUseCase
    func makeKeyboardUseCase() -> Domain.KeyboardUseCase
}
