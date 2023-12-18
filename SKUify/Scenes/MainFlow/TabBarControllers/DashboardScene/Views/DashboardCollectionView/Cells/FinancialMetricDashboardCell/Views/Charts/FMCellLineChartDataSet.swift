//
//  FMCellLineChartDataSet.swift
//  SKUify
//
//  Created by George Churikov on 04.12.2023.
//

import Foundation
import UIKit
import Charts

final class FMCellLineChartDataSet: LineChartDataSet {
    
    required init() {
        super.init()
        setupView()
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
