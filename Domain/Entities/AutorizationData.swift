//
//  AutorizationData.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation

public struct AuthorizationData {
    public let accessToken: String
    public let refreshToken: String
    public let email: String
    public let password: String
    
    public init(
        accessToken: String,
        refreshToken: String,
        email: String,
        password: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.email = email
        self.password = password
    }
    
}

extension AuthorizationData: Equatable {
    public static func == (
        lhs: AuthorizationData,
        rhs: AuthorizationData
    ) -> Bool {
        return lhs.accessToken == rhs.accessToken &&
        lhs.refreshToken == rhs.refreshToken &&
        lhs.email == rhs.email &&
        lhs.password == rhs.password
    }
    
}
