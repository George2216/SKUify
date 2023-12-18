//
//  Tokens.swift
//  Domain
//
//  Created by George Churikov on 15.12.2023.
//

import Foundation

public struct Tokens {
    public let accessToken: String
    public let refreshToken: String
    
    public init(
        accessToken: String,
        refreshToken: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
}

extension Tokens: Equatable {
    public static func == (
        lhs: Tokens,
        rhs: Tokens
    ) -> Bool {
        return lhs.accessToken == rhs.accessToken &&
        lhs.refreshToken == rhs.refreshToken
    }
    
}
