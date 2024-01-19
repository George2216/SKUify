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

    private lazy var markerView = OverviewChartMarkerView(chartView: self)
    private var markerDataStorage: [OverviewChartMarkerView.Input] = []
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        layer.masksToBounds = false
        setupView()
        marker = markerView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        let data = LineChartData(dataSets: input.dataSets)
        self.data = data
        markerDataStorage = input.markerData
        markerView.isHidden = true
    }
    
    
    // Method to call all configuration functions
    func setupView() {
        delegate = self
        configureLegend()
        configureXAxis()
        configureLeftAxis()
        configureRightAxis()
        configureScaling()
        configureAxisColors()
        customizeXAxisLabels()
        addExtraBottomOffset()
        zoomEnabling()
    }
    
    // Method to configure legend properties
    private func configureLegend() {
        legend.enabled = false
    }
    
    // Method to configure X-axis properties
    private func configureXAxis() {
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.drawLabelsEnabled = false
    }
    
    // Method to configure left axis properties
    private func configureLeftAxis() {
        leftAxis.drawGridLinesEnabled = false
        leftAxis.enabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.granularity = 6.0
        leftAxis.axisMinimum = 0.0
    }
    
    // Method to configure right axis properties
    private func configureRightAxis() {
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.granularity = 6.0
        rightAxis.axisMinimum = 0.0
    }
    
    // Method to configure scaling (zooming) on both X and Y axes
    private func configureScaling() {
        scaleXEnabled = false
        scaleYEnabled = false
    }
    
    // Method to configure colors for axis lines and grid lines
    private func configureAxisColors() {
        rightAxis.axisLineColor = .border
        xAxis.axisLineColor = .border
        rightAxis.gridColor = .border
    }
    
    // Method to customize X-axis label rotation, font, and positioning
    private func customizeXAxisLabels() {
        xAxis.labelRotationAngle = -90
        xAxis.labelFont = .manrope(type: .medium, size: 6)
//        xAxis.centerAxisLabelsEnabled = true
    }
    
    // Method to add extra offset to the bottom of the chart
    private func addExtraBottomOffset() {
        extraBottomOffset = 20.0
    }
    
    // Method prohibit using zoom
    private func zoomEnabling() {
        pinchZoomEnabled = false
    }
    
}

//MARK: - Input

extension OverviewCellChartsView {
    struct Input {
        let dataSets: [LineChartDataSet]
        let markerData: [OverviewChartMarkerView.Input]
    }
    
}

//MARK: ChartViewDelegate

extension OverviewCellChartsView: ChartViewDelegate {
    func chartValueSelected(
        _ chartView: ChartViewBase,
        entry: ChartDataEntry,
        highlight: Highlight
    ) {
        let xPosition = Int(highlight.x)
        guard xPosition < markerDataStorage.count else { return }
        let markerData = markerDataStorage[xPosition]
        markerView.setupInput(markerData)
        markerView.isHidden = false
    }
    
    
}
