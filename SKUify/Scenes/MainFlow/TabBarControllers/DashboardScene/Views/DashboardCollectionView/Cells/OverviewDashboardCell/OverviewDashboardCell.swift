//
//  OverviewDashboardCell.swift
//  SKUify
//
//  Created by George Churikov on 03.12.2023.
//

import UIKit

final class OverviewDashboardCell: UICollectionViewCell {
    
    private let overviewTitleLabel = UILabel()
    private let chartsView = OverviewCellChartsView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubviewOverviewTitleLabel()
        addSubviewChartsView()
        
        setupView()
        setOverviewTitleLabel()
        setupOverviewTitleLabel()
        
        let set1 = OverviewCellLineChartDataSet(
            [
            .init(x: 0, y: 0),
            .init(x: 1, y: 10),
            .init(x: 2, y: 2),
            .init(x: 5, y: 17),
            .init(x: 12, y: 25),

            ],
            color: .roiChart
        )
        let set2 = OverviewCellLineChartDataSet(
            [
            .init(x: 0, y: 0),
            .init(x: 3, y: 12),
            .init(x: 5, y: 18),
            .init(x: 6, y: 22),
            .init(x: 8, y: 10),

            ],
            color: .salesChart
        )
        
        chartsView.setDataSets([set1, set2])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
