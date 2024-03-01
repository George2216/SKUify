//
//  DictionaryExtension.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.02.2024.
//

import Foundation

extension Dictionary {
    func toURLParameters() -> String {
        let parameterPairs = self.map { key, value in
            guard value as? String != "" else { return ""}
            return "\(key)=\(value)"
        }
        let str = parameterPairs
            .filter({ $0 != ""})
            .joined(separator: "&")
        print(str)
        return str
    }
    
}
