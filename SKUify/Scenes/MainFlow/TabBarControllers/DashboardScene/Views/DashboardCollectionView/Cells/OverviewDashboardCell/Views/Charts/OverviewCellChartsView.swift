//
//  OverviewCellChartsView.swift
//  SKUify
//
//  Created by George Churikov on 05.12.2023.
//

import Foundation
import UIKit
import Charts

final class OverviewCellChartsView: LineChartView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSets(_ dataSets: [LineChartDataSet]) {
        let data = LineChartData(dataSets: dataSets)
        self.data = data
    }
        
    private func setupView() {
//        xAxis.drawGridLinesEnabled = false
//        leftAxis.drawGridLinesEnabled = false
//        rightAxis.drawGridLinesEnabled = false
        legend.enabled = false
//        xAxis.enabled = false
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        
        // Настройка оси Y
        leftAxis.drawGridLinesEnabled = false
        leftAxis.enabled = false
        rightAxis.drawLabelsEnabled = false
        leftAxis.drawAxisLineEnabled = false
        rightAxis.drawAxisLineEnabled = false
        xAxis.drawAxisLineEnabled = false

        leftAxis.granularity = 6.0
        rightAxis.granularity = 6.0
        rightAxis.axisLineColor = .border
        xAxis.axisLineColor = .border
        rightAxis.gridColor = .border

        isUserInteractionEnabled = false
    }
    
}
