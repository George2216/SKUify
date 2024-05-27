//
//  FulfilmentType.swift
//  SKUify
//
//  Created by George Churikov on 02.05.2024.
//

import Foundation

enum FulfilmentType: String {
    case fba
    case fbm
    case sfp
    
    init(rawValue: String) {
        switch rawValue {
        case "AFN", "fba", "fbm":
            self = .fba
        case "mf", "MFN":
            self = .fbm
        case "sfp", "MFN_PRIME":
            self = .sfp
        default:
            fatalError()
        }
    }
    
    
    var cogsSettingsRawValue: String {
        switch self {
        case .fba:
            return "fbm"
        case .fbm:
            return "mf"
        case .sfp:
            return "sfp"
        }
    }
    
}
