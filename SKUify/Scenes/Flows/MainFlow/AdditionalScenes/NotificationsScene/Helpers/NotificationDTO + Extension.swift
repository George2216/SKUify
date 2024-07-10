//
//  NotificationDTO + Extension.swift
//  SKUify
//
//  Created by George Churikov on 03.07.2024.
//

import Foundation
import Domain

extension NotificationDTO {
    var notificationType: NotificationType {
        switch (type, orderData, productData) {
        case ("Order", let orderData?, _):
            return .order(orderData)
        case ("Product", _, let productData?):
            return .inventory(productData)
        default:
            return .none
        }
    }
    
    var notificationSubtype: String {
        switch notificationType {
        case .order(let data):
            guard data.eventType == "Refunded" else { return "Order" }
            return "Refund"
        case .inventory:
            return "Order"
        default:
            return "Unknown"
        }
    }
    
    func mapToScreenSwitchType() -> ScreenSwitchType {
        switch notificationType {
        case .order(let data):
            let tableType: SalesTableType = notificationSubtype == "Refund" ?
                .refunds : .orders
            return .sales(
                .init(
                    tableType: tableType,
                    searchText: data.amazonOrderId
                )
            )
        case .inventory(let data):
            return .inventory(
                .init(
                    tableType: .orders,
                    searchText: data.asin
                )
            )
        case .none:
            return .none
        }
    }
    
    enum ScreenSwitchType  {
        case sales(_ with: SalesViewModel.SetupModel)
        case inventory(_ with: InventoryViewModel.SetupModel)
        case none
    }
    
}
