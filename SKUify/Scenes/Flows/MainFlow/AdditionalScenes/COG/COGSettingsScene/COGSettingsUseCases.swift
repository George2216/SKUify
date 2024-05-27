//
//  COGSettingsUseCases.swift
//  SKUify
//
//  Created by George Churikov on 22.04.2024.
//

import Foundation
import Domain

public protocol COGSettingsUseCases {
    func makeCOGSInformationUseCase() -> Domain.COGSInformationUseCase
    func makeCOGBbpImoprtStategyUseCase() -> Domain.COGBbpImoprtStategyUseCase
    func makeCOGSettingsUseCase() -> Domain.COGSettingsUseCase
}
