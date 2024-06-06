//
//  SecurityUseCases.swift
//  SKUify
//
//  Created by George Churikov on 05.06.2024.
//

import Foundation
import Domain

public protocol SecurityUseCases {
    func makeUpdatePasswordUseCase() -> Domain.UpdatePasswordUseCase
    func makeKeyboardUseCase() -> Domain.KeyboardUseCase
}
