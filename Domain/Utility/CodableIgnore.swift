//
//  CodableIgnore.swift
//  Domain
//
//  Created by George Churikov on 16.04.2024.
//

import Foundation

@propertyWrapper
public struct Ignore<T> {
    public var wrappedValue: T
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
}

extension Ignore: Encodable where T: Encodable { }
extension Ignore: Decodable where T: Decodable { }

extension KeyedEncodingContainer {
    mutating func encode<T: Encodable>(
        _ value: Ignore<T>,
        forKey key: KeyedEncodingContainer<K>.Key
    ) throws { }
}

extension KeyedDecodingContainer {
    func decode<T: Decodable>(
        _ type: Ignore<T?>.Type,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> Ignore<T?> {
        return try .init(
            wrappedValue: decodeIfPresent(
                T.self,
                forKey: key
            )
        )
    }
    
}
