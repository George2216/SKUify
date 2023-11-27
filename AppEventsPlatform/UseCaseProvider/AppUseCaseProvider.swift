//
//  AppUseCaseProvider.swift
//  AppEventsPlatform
//
//  Created by George Churikov on 27.11.2023.
//

import Foundation
import Domain

final public class AppEventsUseCaseProvider: Domain.AppEventsUseCaseProvider {
    public func makeKeyboardUseCase() -> Domain.KeyboardUseCase {
        KeyboardUseCase()
    }
    
    public init() { }

}
