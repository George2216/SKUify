//
//  OverviewDashboardCell.swift
//  SKUify
//
//  Created by George Churikov on 03.12.2023.
//

import UIKit
import Charts

final class OverviewDashboardCell: UICollectionViewCell {
    
    // MARK: UIElements

    private lazy var overviewTitleLabel = UILabel()
    private lazy var chartsView = OverviewCellChartsView()
    private lazy var datesLabelsStack = HorizontalStack()
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubviewOverviewTitleLabel()
        addSubviewChartsView()
        addSubviewDatesLabelsStack()
        
        setupView()
        setOverviewTitleLabel()
        setupOverviewTitleLabel()
        setupDatesLabelsStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInput(_ input: Input) {
        setupChartsView(input)
        setupDatesLabels(input)
    }
    
    private func setupChartsView(_ input: Input) {
        let dataSets = input.chartsData.map { item in
            let set = OverviewCellLineChartDataSet(
                item.isVisible ? item.points : [],
                color: item.chartType.chartColor
            )
            return set
        }
        chartsView.setupInput(
            .init(
                dataSets: dataSets,
                markerData: input.markerData
            )
        )
    }
    
    private func setupDatesLabels(_ input: Input) {
        datesLabelsStack.views =  input.labels.map { title in
            self.makeDateLabel(title: title)
        }
    }
    
    private func makeDateLabel(title: String) -> UILabel {
        let label = UILabel()
        label.font = .manrope(
            type: .bold,
            size: 12
        )
        label.text = title
        label.textColor = .subtextColor
        label.numberOfLines = 0
        label.contentMode = .center
        return label
    }
    
    private func setOverviewTitleLabel() {
        overviewTitleLabel.text = "Overview"
    }
    
    private func setupDatesLabelsStack() {
        datesLabelsStack.distribution = .equalSpacing
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
    
    private func addSubviewDatesLabelsStack() {
        contentView.addSubview(datesLabelsStack)
        datesLabelsStack.snp.makeConstraints { make in
            make.top
                .equalTo(chartsView.snp.bottom)
            make.horizontalEdges
                .equalToSuperview()
                .inset(10)
            make.bottom
                .equalToSuperview()
                .inset(10)
        }
    }
    
    private func addSubviewChartsView() {
        contentView.addSubview(chartsView)
        chartsView.snp.makeConstraints { make in
            make.top
                .equalTo(overviewTitleLabel.snp.bottom)
            make.directionalHorizontalEdges
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

//MARK: - Input

extension OverviewDashboardCell {
    struct Input {
        var labels: [String]
        var chartsData: [ChartItem]
        var markerData: [OverviewChartMarkerView.Input]
        
        struct ChartItem {
            var chartType: ChartType
            var points: [CGPoint]
            var isVisible: Bool
        }
    }
    
    
}

