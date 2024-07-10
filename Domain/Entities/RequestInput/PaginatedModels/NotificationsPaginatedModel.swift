//
//  NotificationsPaginatedModel.swift
//  Domain
//
//  Created by George Churikov on 26.06.2024.
//

import Foundation

public struct NotificationsPaginatedModel {
    public let limit = 15
    public var offset: Int? = nil
    public static func base() -> Self {
        return .init()
    }
    
}
