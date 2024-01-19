//
//  SettingsUseCases.swift
//  SKUify
//
//  Created by George Churikov on 01.12.2023.
//

import Foundation
import Domain

protocol SettingsUseCases {
    func makeLoginStateUseCase() -> Domain.LoginStateUseCase
    func makeAppVersionUseCase() -> Domain.AppVersionUseCase
}
