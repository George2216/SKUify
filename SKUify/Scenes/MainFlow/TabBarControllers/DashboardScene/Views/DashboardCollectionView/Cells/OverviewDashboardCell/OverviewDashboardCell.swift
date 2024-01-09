//
//  OverviewDashboardCell.swift
//  SKUify
//
//  Created by George Churikov on 03.12.2023.
//

import UIKit
import Charts

final class OverviewDashboardCell: UICollectionViewCell {
    
    private let overviewTitleLabel = UILabel()
    private lazy var chartsView = OverviewCellChartsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubviewOverviewTitleLabel()
        addSubviewChartsView()
        
        setupView()
        setOverviewTitleLabel()
        setupOverviewTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInput(_ input: Input) {
        let dataSets = input.chartsData.map { item in
            OverviewCellLineChartDataSet(
                item.points,
                color: item.chartType.chartColor
            )
        }
        chartsView.setupInput(
            .init(
                dataSets: dataSets,
                labels: input.labels,
                markerData: input.markerData
            )
        )

    }
    
    private func setOverviewTitleLabel() {
        overviewTitleLabel.text = "Overview"
    }
    
    private func setupOverviewTitleLabel() {
        overviewTitleLabel.font = .manrope(
            type: .extraBold,
            size: 20
        )
        overviewTitleLabel.textColor = .textColor
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    // MARK: Add to subview
    
    private func addSubviewChartsView() {
        contentView.addSubview(chartsView)
        chartsView.snp.makeConstraints { make in
            make.top
                .equalTo(overviewTitleLabel.snp.bottom)
            make.directionalHorizontalEdges
                .bottom
                .equalToSuperview()
                .inset(10)
        }
    }
    
    private func addSubviewOverviewTitleLabel() {
        contentView.addSubview(overviewTitleLabel)
        overviewTitleLabel.snp.makeConstraints { make in
            make.top
                .leading
                .equalToSuperview()
                .inset(10)
        }
    }
}

extension OverviewDashboardCell {
    struct Input {
        var labels: [String]
        var chartsData: [ChartItem]
        var markerData: [OverviewChartMarkerView.Input]
        
        struct ChartItem {
            var chartType: ChartType
            var points: [CGPoint]
        }
    }
    
    
}

