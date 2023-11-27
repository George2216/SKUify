//
//  AppManagerUseCases.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import Domain

protocol AppManagerUseCases {
    func makeLoginStateUseCase() -> Domain.LoginStateUseCase
}
