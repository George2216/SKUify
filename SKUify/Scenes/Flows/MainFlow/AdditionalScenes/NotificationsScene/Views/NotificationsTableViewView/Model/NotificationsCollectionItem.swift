//
//  NotificationsCollectionItem.swift
//  SKUify
//
//  Created by George Churikov on 26.06.2024.
//

import Foundation

enum NotificationsCollectionItem {
    case notification(_ input: NotificationCell.Input)
}

extension NotificationsCollectionItem {
    func mapToId() -> Int {
        switch self {
        case .notification(let input):
            return input.id
        }
    }
    
}
