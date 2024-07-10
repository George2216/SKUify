//
//  NotificationsUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 26.06.2024.
//

import Foundation
import Domain
import RxSwift

final class NotificationsUseCase: Domain.NotificationsUseCase {
    private let network: Domain.NotificationsNetwork
    
    init(network: Domain.NotificationsNetwork) {
        self.network = network
    }
    
    func getNotifications(_ model: NotificationsPaginatedModel) -> Observable<[NotificationDTO]> {
        network.getNotifications(model)
            .map { $0.results }
    }
    
    
}
