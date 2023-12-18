//
//  SimpleDashboardChartCell.swift
//  SKUify
//
//  Created by George Churikov on 03.12.2023.
//

import UIKit
import Charts
import RxSwift
import RxCocoa

final class FinancialMetricDashboardCell: UICollectionViewCell {
    

    private let metricImageView = FMCellBackgroundImage()
    private let metricSwitch = SmallSwitch()
    private let chartView = FMCellChartsView()
    private let infoButton = DefaultButton()
    private let moneyLabel = UILabel()
    private let detailView = FMDetailView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.autoresizingMask = .flexibleHeight

        setupCell()
        setupMoneyLabel()
        addSubviewMetricImageView()
        addSubviewmetricSwitch()
        addSubviewChartView()
        addSubviewInfoButton()
        addSubviewMoneyLabel()
        addSubviewDetailView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInput(_ input: Input) {
        metricImageView.setImage(input.cellType.image)
        setToChartsData(input)
        setToInfoButton(input)
        setToDetailView(input)
        moneyLabel.text = input.sum
        metricSwitch.isOn = input.switchState
    }
    

    private func setToDetailView(_ input: Input) {
        detailView.setInput(
            .init(
                isUp: input.isUp,
                percentage: input.precentage,
                last90Days: input.last90DaysPrice
            )
        )
    }
    
    private func setToChartsData(_ input: Input) {
        let dataSet = FMCellLineChartDataSet(
            input.points,
            color: input.cellType.chartColor
        )
      
        chartView.setDataSets([dataSet])
    }
    
    private func setToInfoButton(_ input: Input) {
        infoButton.config = input.infoConfig
    }
    
    // MARK: Add to subview
    
    private func addSubviewDetailView() {
        contentView.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.top
                .equalTo(moneyLabel.snp.bottom)
            make.directionalHorizontalEdges
                .equalToSuperview()
                .inset(10)
            make.bottom.equalToSuperview()
                .inset(10)
        }
    }
    
    private func addSubviewMoneyLabel() {
        contentView.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { make in
            make.leading
                .equalToSuperview()
                .inset(10)
            make.top
                .equalTo(infoButton.snp.bottom)
        }
    }
    
    private func addSubviewInfoButton() {
        contentView.addSubview(infoButton)
        infoButton.snp.makeConstraints { make in
            make.top
                .equalTo(chartView.snp.bottom)
                .offset(10)
            make.leading
                .equalToSuperview()
                .inset(10)
        }
    }

    private func addSubviewChartView() {
        contentView.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.directionalHorizontalEdges
                .equalToSuperview()
            make.top
                .equalTo(metricImageView.snp.bottom)
                .offset(10)
            make.height
                .equalTo(55)
        }

    }
    
    private func addSubviewMetricImageView() {
        contentView.addSubview(metricImageView)
        metricImageView.snp.makeConstraints { make in
            make.top
                .leading
                .equalToSuperview()
                .inset(10)
        }
    }
    
    private func addSubviewmetricSwitch() {
        contentView.addSubview(metricSwitch)
        metricSwitch.snp.makeConstraints { make in
            make.top
                .trailing
                .equalToSuperview()
                .inset(10)
        }
    }
    
    // MARK: Setup views

    private func setupMoneyLabel() {
        moneyLabel.font = .manrope(
            type: .extraBold,
            size: 15
        )
        moneyLabel.textColor = .textColor
    }
    
    private func setupCell() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 12
    }
    
}


// MARK: Make Cell type

extension FinancialMetricDashboardCell {
    enum CellType {
        case sales
        case unitsSold
        case profit
        case refunds
        case margin
        case roi
    
        var chartColor: UIColor {
            switch self {
            case .sales:
                return .salesChart
            case .unitsSold:
                return .unitsSoldChart
            case .profit:
                return .profitChart
            case .refunds:
                return .refundsChart
            case .margin:
                return .marginChart
            case .roi:
                return .roiChart
            }
            
        }
        
        var image: UIImage {
            switch self {
            case .sales:
                return .sales
            case .unitsSold:
                return .unitsSold
            case .profit:
                return .profit
            case .refunds:
                return .refunds
            case .margin:
                return .margin
            case .roi:
                return .roi
            }
            
        }
    }
    
}

// MARK: Make input

extension FinancialMetricDashboardCell {
    struct Input {
        let cellType: CellType
        var switchState: Bool
        var sum: String
        var precentage: String
        var isUp: Bool
        var points: [CGPoint]
        let last90DaysPrice: String
        let infoConfig: DefaultButton.Config
        let switchChangedOn: ((Bool)->())?
    }
    
}
