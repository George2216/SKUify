//
//  Data.swift
//  NetworkPlatform
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
