//
//  SectionType.swift
//  SKUify
//
//  Created by George Churikov on 03.12.2023.
//

import Foundation
import RxDataSources

enum DashboardSectionType: Equatable {
    case defaultSection(
        header: String,
        footer: String
    )
    case marketplaceSection(
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
        ),
                .marketplaceSection(
                    let header,
                    let footer
                ):
            return (header, footer)
        }
    }
}

