//
//  OverviewCellLineChartDataSet.swift
//  SKUify
//
//  Created by George Churikov on 05.12.2023.
//

import Foundation
import UIKit
import DGCharts

final class OverviewCellLineChartDataSet: LineChartDataSet {
    
    required init() {
        super.init()
        
    }

    convenience init(
        _ points: [CGPoint],
        color: UIColor
    ) {
        let entries: [ChartDataEntry] = points.map { point in
            ChartDataEntry(
                x: Double(point.x),
                y: Double(point.y)
            )
        }
        self.init(entries)
        colors = [color]
        setupView()
    }
    
    private func setupView() {
        drawCirclesEnabled = false
        drawValuesEnabled = false
        mode = .cubicBezier
        lineWidth = 3.0
    }
}
