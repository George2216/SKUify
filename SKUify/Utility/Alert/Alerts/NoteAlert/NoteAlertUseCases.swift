//
//  NoteAlertUseCases.swift
//  SKUify
//
//  Created by George Churikov on 26.03.2024.
//

import Foundation
import Domain

protocol NoteAlertUseCases {
    func makeKeyboardUseCase() -> Domain.KeyboardUseCase
}
