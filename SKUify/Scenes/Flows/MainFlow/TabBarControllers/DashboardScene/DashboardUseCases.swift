//
//  DashboardUseCases.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import Foundation
import Domain

protocol DashboardUseCases {
    func makeChartsUseCase() -> Domain.ChartsUseCase
    func makeMarketplacesUseCase() -> Domain.MarketplacesUseCase
}