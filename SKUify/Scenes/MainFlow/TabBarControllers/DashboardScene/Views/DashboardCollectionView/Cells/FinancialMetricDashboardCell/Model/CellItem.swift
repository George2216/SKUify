//
//  CellItem.swift
//  SKUify
//
//  Created by George Churikov on 03.12.2023.
//

import Foundation

enum DashboardCollectionItem {
    case financialMetric(_ input: FinancialMetricDashboardCell.Input)
    case overview
    case marketplace(_ input: MarketplaceDashboardCell.Input)
}