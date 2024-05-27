//
//  Array.swift
//  NetworkPlatform
//
//  Created by George Churikov on 22.05.2024.
//

import Foundation

extension Array where Element: Encodable {
    func toData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
}
