//
//  NotificationsUseCase.swift
//  Domain
//
//  Created by George Churikov on 26.06.2024.
//

import Foundation
import RxSwift

public protocol NotificationsUseCase {
    func getNotifications(_ model: NotificationsPaginatedModel) -> Observable<[NotificationDTO]>
}
