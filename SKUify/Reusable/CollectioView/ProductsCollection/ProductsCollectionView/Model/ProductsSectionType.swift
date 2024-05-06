//
//  SalesSectionType.swift
//  SKUify
//
//  Created by George Churikov on 09.02.2024.
//

import Foundation

enum ProductsSectionType: Equatable {
    case defaultSection(
        header: String,
        footer: String
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

