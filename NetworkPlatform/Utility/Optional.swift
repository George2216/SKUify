//
//  StringExtension.swift
//  NetworkPlatform
//
//  Created by George Churikov on 20.03.2024.
//

import Foundation

//extension Optional where Wrapped == String {
//    var emptyOrValue: String {
//        
//    }
//    
//}

extension Optional where Wrapped: CustomStringConvertible {
    var toStringOrEmpty: String {
        switch self {
        case .none:
            return ""
        case .some(let wrapped):
            return String(wrapped)
        }
    }
}
