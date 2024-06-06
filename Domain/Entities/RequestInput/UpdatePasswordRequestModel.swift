//
//  UpdatePasswordRequestModel.swift
//  Domain
//
//  Created by George Churikov on 06.06.2024.
//

import Foundation

public struct UpdatePasswordRequestModel: Encodable {
    public var oldPassword: String
    public var newPassword: String
    public var confirmNewPassword: String
    
    public static func empty() -> Self {
        .init(
            oldPassword: "",
            newPassword: "",
            confirmNewPassword: ""
        )
    }
    
    private enum CodingKeys: String, CodingKey {
        case oldPassword = "old_password"
        case newPassword = "new_password"
        case confirmNewPassword = "confirm_password"

    }

}
