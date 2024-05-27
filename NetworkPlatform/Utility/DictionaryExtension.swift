//
//  DictionaryExtension.swift
//  NetworkPlatform
//
//  Created by George Churikov on 07.02.2024.
//

import Foundation
import Alamofire

extension Dictionary {
    func toURLParameters() -> String {
        let parameterPairs = self.map { key, value in
            guard value as? String != "" else { return ""}
            return "\(key)=\(value)"
        }
        let str = parameterPairs
            .filter({ $0 != ""})
            .joined(separator: "&")
        return str
    }
    
}

extension Dictionary {
    func toData() -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}

extension Dictionary where Key == String, Value == String {
    func toHeaders() -> HTTPHeaders {
        var headers: HTTPHeaders = [:]
        for (key, value) in self  {
            headers.add(name: key, value: value)
        }
        return headers
    }
    
}
