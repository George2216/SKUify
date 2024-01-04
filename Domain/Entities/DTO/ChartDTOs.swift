//
//  ChartDTOs.swift
//  Domain
//
//  Created by George Churikov on 22.12.2023.
//

import Foundation

public struct ChartMainDTO: Decodable {
    public let chart: ChartDTO
}

public struct ChartDTO: Decodable {
    public let currency: String
    public let sales: Double
    public let salesCompared: Double?
    public let profit: Double
    public let profitCompared: Double?
    public let roi: Double
    public let roiCompared: Double?
    public let margin: Double
    public let marginCompared: Double?
    public let refunds: Double
    public let refundsCompared: Double?
    public let unitsSold: Double
    public let unitsSoldCompared: Double?
    public let chartData: ChartDataDTO
    public let marketplaces: [ChartMarketplace]
    
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
    public let labels: [String]
    public let legendLabels: [String]
    public let legendLabelsCompared: [String]?
    public let dates: [String]
    public let compareDates: [String]?
    public let sales: ChartPoints
    public let profit: ChartPoints
    public let unitsSold: ChartPoints
    public let roi: ChartPoints
    public let margin: ChartPoints
    public let refunds: ChartPoints
    
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
    public let values: [Double]
    public let compare: [Double]?
    
    private enum CodingKeys: String, CodingKey {
        case values = "values"
        case compare = "compare"
    }
}

public struct ChartMarketplace: Decodable {
    public let id: String
    public let marketplace: String
    public let sales: Double
    public let profit: Double
    public let refunds: Double
    public let unitsSold: String
    public let roi: Double
    public let margin: Double
    public let country: String
    
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
