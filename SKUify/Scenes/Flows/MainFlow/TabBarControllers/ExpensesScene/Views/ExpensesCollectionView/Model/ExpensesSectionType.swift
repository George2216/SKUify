//
//  ExpensesSectionType.swift
//  SKUify
//
//  Created by George Churikov on 07.05.2024.
//

import Foundation

enum ExpensesSectionType: Equatable {
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

