//
//  DefaultSectionType.swift
//  SKUify
//
//  Created by George Churikov on 26.06.2024.
//

import Foundation

enum DefaultSectionType: Equatable {
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
