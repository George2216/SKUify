//
//  AppEventsProvider.swift
//  Domain
//
//  Created by George Churikov on 26.11.2023.
//

import Foundation

public protocol AppEventsUseCaseProvider {
    func makeKeyboardUseCase() -> Domain.KeyboardUseCase
    func makeAppVersionUseCase() -> Domain.AppVersionUseCase
}
