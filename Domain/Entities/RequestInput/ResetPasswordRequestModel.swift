//
//  ResetPasswordRequestModel.swift
//  Domain
//
//  Created by George Churikov on 10.06.2024.
//

import Foundation

public struct ResetPasswordRequestModel: Encodable {
    public let email: String
    
    public init(email: String) {
        self.email = email
    }
    
}
