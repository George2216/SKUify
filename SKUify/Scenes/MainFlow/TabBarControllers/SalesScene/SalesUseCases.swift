//
//  SalesUseCases.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import Domain

protocol SalesUseCases {
    func makeSalesRefundsUseCase() -> Domain.SalesRefundsUseCase
    func makeMarketplacesUseCase() -> Domain.MarketplacesUseCase
}
