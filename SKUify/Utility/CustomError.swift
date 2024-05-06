//
//  CustomError.swift
//  SKUify
//
//  Created by George Churikov on 18.04.2024.
//

import Foundation

struct CustomError: Error, LocalizedError {
    let message: String

    var errorDescription: String? {
        return NSLocalizedString(
            message,
            comment: ""
        )
    }
    
}

