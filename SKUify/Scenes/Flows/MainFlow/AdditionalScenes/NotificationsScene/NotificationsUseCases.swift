//
//  NotificationsUseCases.swift
//  SKUify
//
//  Created by George Churikov on 07.06.2024.
//

import Foundation
import Domain

protocol NotificationsUseCases {
    func makeNotificationsUseCase() -> Domain.NotificationsUseCase
}
