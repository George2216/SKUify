//
//  ProfileUseCases.swift
//  SKUify
//
//  Created by George Churikov on 18.01.2024.
//

import Foundation
import Domain

protocol ProfileUseCases {
    func makeUserDataUseCase() -> Domain.UserDataUseCase
    func makeUserIdUseCase() -> Domain.UserIdUseCase
}
