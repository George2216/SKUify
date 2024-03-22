//
//  BoolExtension.swift
//  NetworkPlatform
//
//  Created by George Churikov on 20.03.2024.
//

import Foundation

public extension Bool {
    var trueOrEmptyString: String {
        return self ? "true" : ""
    }
    
}
