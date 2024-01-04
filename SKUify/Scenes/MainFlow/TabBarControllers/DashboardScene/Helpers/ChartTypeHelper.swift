//
//  ChartTypeHelper.swift
//  SKUify
//
//  Created by George Churikov on 03.01.2024.
//

import Foundation
import UIKit

enum ChartType: String {
    case sales
    case unitsSold
    case profit
    case refunds
    case margin
    case roi

    var chartColor: UIColor {
        switch self {
        case .sales:
            return .salesChart
        case .unitsSold:
            return .unitsSoldChart
        case .profit:
            return .profitChart
        case .refunds:
            return .refundsChart
        case .margin:
            return .marginChart
        case .roi:
            return .roiChart
        }
        
    }
    
    var image: UIImage {
        switch self {
        case .sales:
            return .sales
        case .unitsSold:
            return .unitsSold
        case .profit:
            return .profit
        case .refunds:
            return .refunds
        case .margin:
            return .margin
        case .roi:
            return .roi
        }
    }

}
