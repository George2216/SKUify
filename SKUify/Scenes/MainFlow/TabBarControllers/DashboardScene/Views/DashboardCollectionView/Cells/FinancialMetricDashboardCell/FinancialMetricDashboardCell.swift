//
//  SimpleDashboardChartCell.swift
//  SKUify
//
//  Created by George Churikov on 03.12.2023.
//

import UIKit
import DGCharts
import RxSwift
import RxCocoa

final class FinancialMetricDashboardCell: UICollectionViewCell {
    private var disposeBag = DisposeBag()

    // MARK: - UI elements
    
    private let metricImageView = FMCellBackgroundImage()
    private let metricSwitch = SmallSwitch()
    private let chartView = FMCellChartsView()
    private let infoButton = DefaultButton()
    private let sumLabel = UILabel()
    private let detailView = FMDetailView()
    
    //MARK: - Initializers

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
        disposeBag = DisposeBag()
        metricImageView.setImage(input.cellType.image)
        setToChartsData(input)
        setToInfoButton(input)
        setToDetailView(input)
        bindSwitchChanges(input)
        
        sumLabel.text = input.sum
        metricSwitch.isOn = input.switchState
    }
    

    private func setToDetailView(_ input: Input) {
        detailView.setInput(input.detailInput)
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
    
    private func bindSwitchChanges(_ input: Input) {
        metricSwitch.rx
            .isOn
            .changed
            .subscribe(onNext:{ isOn in
                input.switchChangedOn?(isOn)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Add to subview
    
    private func addSubviewDetailView() {
        contentView.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.top
                .equalTo(sumLabel.snp.bottom)
            make.directionalHorizontalEdges
                .equalToSuperview()
                .inset(10)
            make.bottom.equalToSuperview()
                .inset(10)
        }
    }
    
    private func addSubviewMoneyLabel() {
        contentView.addSubview(sumLabel)
        sumLabel.snp.makeConstraints { make in
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
        sumLabel.font = .manrope(
            type: .extraBold,
            size: 15
        )
        sumLabel.textColor = .textColor
    }
    
    private func setupCell() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 12
    }
    
}

// MARK: Make input

extension FinancialMetricDashboardCell {
    struct Input {
        let cellType: ChartType
        var detailInput: FMDetailView.Input
        var switchState: Bool
        var sum: String
        var points: [CGPoint]
        let infoConfig: DefaultButton.Config
        let switchChangedOn: ((Bool)->())?
    }
    
}
