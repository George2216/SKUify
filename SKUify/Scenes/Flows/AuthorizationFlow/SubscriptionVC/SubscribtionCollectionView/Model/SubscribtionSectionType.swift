//
//  SubscribtionSectionType.swift
//  SKUify
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation

enum SubscribtionSectionType: Equatable {
    case defaultSection(
        header: String = "",
        footer: String = ""
    )

    var headerFooter: (
        header: String,
        footer: String
    ) {
        switch self {
        case .defaultSection(
            let header,
            let footer
        ):
            return (header, footer)
        }
    }
    
}

