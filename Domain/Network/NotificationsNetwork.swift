//
//  NotificationsNetwork.swift
//  Domain
//
//  Created by George Churikov on 26.06.2024.
//

import Foundation
import RxSwift

public protocol NotificationsNetwork {
    func getNotifications(_ model: NotificationsPaginatedModel) -> Observable<NotificationsDTO>
}

