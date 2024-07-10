//
//  NotificationsDTO.swift
//  Domain
//
//  Created by George Churikov on 26.06.2024.
//

import Foundation

public struct NotificationsDTO: Decodable {
    public let results: [NotificationDTO]
    public init(results: [NotificationDTO]) {
        self.results = results
    }
}

public struct NotificationDTO: Decodable {
    public let id: Int
    public let date: String
    public let type: String
    public let orderData: NotificationOrderDataDTO?
    public let productData: NotificationProductDataDTO?
        
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case orderData = "order_data"
        case date = "created_at"
        case productData = "product_data"
    }
    
    public init(
        id: Int,
        date: String,
        type: String,
        orderData: NotificationOrderDataDTO? = nil,
        productData: NotificationProductDataDTO? = nil
    ) {
        self.id = id
        self.date = date
        self.type = type
        self.orderData = orderData
        self.productData = productData
    }
    
}

public struct NotificationOrderDataDTO: Decodable {
    public let name: String
    public let asin: String
    public let amazonOrderId: String
    public let eventType: String
    public let amount: Double
    
    public init(
        name: String,
        asin: String,
        amazonOrderId: String,
        eventType: String,
        amount: Double
    ) {
        self.name = name
        self.asin = asin
        self.amazonOrderId = amazonOrderId
        self.eventType = eventType
        self.amount = amount
    }
    private enum CodingKeys: String, CodingKey {
        case name
        case asin
        case amazonOrderId = "amazon_order_id"
        case eventType = "event_type"
        case amount
    }
    
}

public struct NotificationProductDataDTO: Decodable {
    public let name: String
    public let asin: String
    public let eventType: String
    
    public init(
        name: String,
        asin: String,
        eventType: String
    ) {
        self.name = name
        self.asin = asin
        self.eventType = eventType
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case asin
        case eventType = "event_type"
    }
    
}

public enum NotificationType {
    case order(_ data: NotificationOrderDataDTO)
    case inventory(_ data: NotificationProductDataDTO)
    case none
}
