//
//  UserId.swift
//  Domain
//
//  Created by George Churikov on 03.01.2024.
//

import Foundation

public struct UserId {
    public let userId: Int
    
    public init(userId: Int) {
        self.userId = userId
    }
    
}

extension UserId: Equatable {
    public static func == (
        lhs: UserId,
        rhs: UserId
    ) -> Bool {
        return lhs.userId == rhs.userId
    }
    
}

