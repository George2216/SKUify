//
//  BBPImportStrategy.swift
//  SKUify
//
//  Created by George Churikov on 02.05.2024.
//

import Foundation

enum BBPImportStrategy: String {
    case skuify
    case bbp
    case edit
    case none
    
    init(rawValue: String) {
        switch rawValue {
        case "sumfully":
            self = .skuify
        case "bbp":
            self = .bbp
        case "edit":
            self = .edit
        default:
            self = .none
        }
    }
    
    var title: String {
        switch self {
        case .skuify:
            return "SKUIfy"
        case .bbp:
            return "BBP"
        case .edit:
            return "Edit"
        case .none:
            return ""
        }
    }
    
    var key: String {
        switch self {
        case .skuify:
            return "sumfully"
        case .bbp:
            return "bbp"
        case .edit:
            return "edit"
        case .none:
            fatalError()
        }
    }
    
}
