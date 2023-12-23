//
//  ChartDTOs.swift
//  Domain
//
//  Created by George Churikov on 22.12.2023.
//

import Foundation

public struct ChartMainDTO: Decodable {
    let chart: ChartDTO
}

public struct ChartDTO: Decodable {
    let currency: String
    let sales: Double
    let salesCompared: Double
    let profit: Double
    let profitCompared: Double
    let roi: Double
    let roiCompared: Double
    let margin: Double
    let marginCompared: Double
    let refunds: Double
    let refundsCompared: Double
    let unitsSold: Double
    let unitsSoldCompared: Double
    let chartData: ChartDataDTO
    let marketplaces: [ChartMarketplace]
    
    private enum CodingKeys: String, CodingKey {
        case currency = "currency"
        case sales = "sales"
        case salesCompared = "sales_compared"
        case profit = "profit"
        case profitCompared = "profit_compared"
        case roi = "roi"
        case roiCompared = "roi_compared"
        case margin = "margin"
        case marginCompared = "margin_compared"
        case refunds = "refunds"
        case refundsCompared = "refunds_compared"
        case unitsSold = "units_sold"
        case unitsSoldCompared = "units_sold_compared"
        case chartData = "chart_data"
        case marketplaces = "by_marketplaces"

    }

}

public struct ChartDataDTO: Decodable {
    let labels: [String]
    let legendLabels: [String]
    let legendLabelsCompared: [String]
    let dates: [String]
    let compareDates: [String]
    let sales: [ChartPoints]
    let profit: [ChartPoints]
    let unitsSold: [ChartPoints]
    let roi: [ChartPoints]
    let margin: [ChartPoints]
    let refunds: [ChartPoints]
    
    private enum CodingKeys: String, CodingKey {
        case labels = "labels"
        case legendLabels = "legend_labels"
        case legendLabelsCompared = "legend_labels_compared"
        case dates = "dates"
        case compareDates = "compare_dates"
        case sales = "sales"
        case profit = "profit"
        case unitsSold = "units_sold"
        case roi = "roi"
        case margin = "margin"
        case refunds = "refunds"
    }
    
}

public struct ChartPoints: Decodable {
    let values: [Double]
    let compare: [Double]
}

public struct ChartMarketplace: Decodable {
    let id: String
    let marketplace: String
    let sales: Double
    let profit: Double
    let refunds: Double
    let unitsSold: Double
    let roi: Double
    let margin: Double
    let country: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case marketplace = "marketplace"
        case sales = "sales"
        case profit = "profit"
        case refunds = "refunds"
        case unitsSold = "units_sold"
        case roi = "roi"
        case margin = "margin"
        case country = "country"
    }
    
}
