//
//  CompanyInformationUseCases.swift
//  SKUify
//
//  Created by George Churikov on 29.01.2024.
//

import Foundation
import Domain

protocol CompanyInformationUseCases {
    func makeUserDataUseCase() -> Domain.UserDataUseCase
    func makeUserIdUseCase() -> Domain.UserIdUseCase
    func makeKeyboardUseCase() -> Domain.KeyboardUseCase
}
