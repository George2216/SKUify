//
//  OptionalExtension.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.02.2024.
//

import Foundation

extension Optional {
    var stringValue: String {
        switch self {
        case .some(let value as CustomStringConvertible):
            return value.description
        case .some(let value as String):
            return value
        case .some(let value):
            return "\(value)"
        case .none:
            return ""
        }
    }
}
