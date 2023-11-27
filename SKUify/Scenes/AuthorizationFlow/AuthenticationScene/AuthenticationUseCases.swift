//
//  LoginUseCases.swift
//  SKUify
//
//  Created by George Churikov on 16.11.2023.
//

import Foundation
import Domain

protocol AuthenticationUseCases {
    func makeLoginStateUseCase() -> Domain.LoginStateUseCase
    func makeKeyboardUseCase() -> Domain.KeyboardUseCase
}
