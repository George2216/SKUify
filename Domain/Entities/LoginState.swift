//
//  LoginState.swift
//  Domain
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation

public struct LoginState {
    public let isLogged: Bool
    
    public init(isLogged: Bool) {
        self.isLogged = isLogged
    }
}

extension LoginState: Equatable {
    public static func == (
        lhs: LoginState,
        rhs: LoginState
    ) -> Bool {
        return lhs.isLogged == rhs.isLogged
    }
}

