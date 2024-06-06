//
//  UpdatePasswordRequestModel + Extension.swift
//  SKUify
//
//  Created by George Churikov on 06.06.2024.
//

import Foundation
import Domain

extension UpdatePasswordRequestModel {
    
    var isValidData: Bool {
        !(
            oldPassword.isEmpty ||
            newPassword.isEmpty ||
            confirmNewPassword.isEmpty ||
            newPassword != confirmNewPassword
        )
    }

}
