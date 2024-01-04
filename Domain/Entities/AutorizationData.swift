//
//  AutorizationData.swift
//  Domain
//
//  Created by George Churikov on 07.12.2023.
//

import Foundation

public struct AuthorizationData {
    public let email: String
    public let password: String
    
    public init(
        email: String,
        password: String
    ) {
        self.email = email
        self.password = password
    }
    
}

extension AuthorizationData: Equatable {
    public static func == (
        lhs: AuthorizationData,
        rhs: AuthorizationData
    ) -> Bool {
        return lhs.email == rhs.email &&
        lhs.password == rhs.password
    }
    
}
