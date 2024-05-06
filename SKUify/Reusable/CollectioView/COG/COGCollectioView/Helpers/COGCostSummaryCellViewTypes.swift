//
//  COGCostSummaryCellViewTypes.swift
//  SKUify
//
//  Created by George Churikov on 05.04.2024.
//

import Foundation

enum COGCostSummaryViewType {
    case label(_ text: String)
    case buttons(_ configs: [DefaultButton.Config])
    case none
}
