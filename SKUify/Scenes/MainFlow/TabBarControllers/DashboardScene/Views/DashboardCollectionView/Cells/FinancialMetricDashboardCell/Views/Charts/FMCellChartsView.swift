//
//  FMCellChartsView.swift
//  SKUify
//
//  Created by George Churikov on 04.12.2023.
//

import Foundation
import UIKit
import Charts

final class FMCellChartsView: LineChartView {

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
        xAxis.drawGridLinesEnabled = false
        leftAxis.drawGridLinesEnabled = false
        rightAxis.drawGridLinesEnabled = false
        legend.enabled = false
        xAxis.enabled = false
        leftAxis.enabled = false
        rightAxis.enabled = false
        
        isUserInteractionEnabled = false
    }
    
}
