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

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted, .sortedKeys, .fragmentsAllowed, .withoutEscapingSlashes]
              ),
              let prettyJSON = NSString(
                data: data,
                encoding: String.Encoding.utf8.rawValue
              ) else {
            return nil
        }
        
        return prettyJSON
    }
    
}
