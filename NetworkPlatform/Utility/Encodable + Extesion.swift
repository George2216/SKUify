//
//  Encodable + Extesion.swift
//  NetworkPlatform
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            return try JSONSerialization.jsonObject(
                with: data,
                options: []
            ) as? [String: Any] ?? [:]
        } catch {
            print("\(error)")
            return [:]
        }
    }
}
