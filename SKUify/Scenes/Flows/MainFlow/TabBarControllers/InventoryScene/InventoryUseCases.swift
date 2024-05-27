//
//  InventoryUseCases.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import Domain

protocol InventoryUseCases {
    func makeInventoryUseCase() -> Domain.InventoryUseCase
    func makeMarketplacesUseCase() -> Domain.MarketplacesUseCase
    func makeNoteInventoryUseCase() -> Domain.NoteUseCase
}
