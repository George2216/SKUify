//
//  SalesUseCases.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import Domain

protocol SalesUseCases {
    func makeSalesUseCase() -> Domain.SalesUseCase
    func makeMarketplacesUseCase() -> Domain.MarketplacesUseCase
    func makeNoteSalesUseCase() -> Domain.NoteUseCase
}
