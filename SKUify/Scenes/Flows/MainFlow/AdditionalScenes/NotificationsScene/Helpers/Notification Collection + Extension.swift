//
//  Notification Collection + Extension.swift
//  SKUify
//
//  Created by George Churikov on 27.06.2024.
//

import Foundation
import Domain

extension Collection where Element == NotificationDTO {
    func groupedByDay() -> [Date: [NotificationDTO]] {
        let calendar = Calendar.current
        var groupedNotifications = [Date: [NotificationDTO]]()
        
        for notification in self {
            guard let date = notification.date.toDate() else {
                continue
            }
            let startOfDay = calendar.startOfDay(for: date)
            if groupedNotifications[startOfDay] != nil {
                groupedNotifications[startOfDay]?.append(notification)
            } else {
                groupedNotifications[startOfDay] = [notification]
            }
        }
        
        return groupedNotifications
    }
    
}
