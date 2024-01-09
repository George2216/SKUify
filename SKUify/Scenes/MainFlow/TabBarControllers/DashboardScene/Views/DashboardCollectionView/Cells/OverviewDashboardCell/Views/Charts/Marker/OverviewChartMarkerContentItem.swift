//
//  OverviewChartMarkerContentItem.swift
//  SKUify
//
//  Created by George Churikov on 04.01.2024.
//

import Foundation
import SnapKit

final class OverviewChartMarkerContentItem: UIView {
    
    //MARK: - UI elements

    private let dateLabel = UILabel()
    private let valueLabel = UILabel()
    private let chartImageView = UIImageView()
    
    private var contentStack = HorizontalStack()
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
        setupChartImageView()
        setupDateLabel()
        setupValueLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(
        _ input: Input,
        chartType: ChartType
    ) {
        dateLabel.text = input.date
        valueLabel.text = input.value
        chartImageView.tintColor = chartType.chartColor
    }
    
    
    
    //MARK: - Setup methods

    private func setupChartImageView() {
        chartImageView.image = UIImage(systemName: "minus")
        chartImageView.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
    }
    
    private func setupDateLabel() {
        dateLabel.textColor = .subtextColor
        dateLabel.font = .manrope(
            type: .semiBold,
            size: 10
        )
        dateLabel.snp.makeConstraints { make in
            make.leading
                .equalTo(chartImageView.snp.trailing)
                .offset(10)
        }
    }
    
    private func setupValueLabel() {
        valueLabel.textColor = .textColor
        valueLabel.font = .manrope(
            type: .semiBold,
            size: 10
        )
    }
    
    private func setupStack() {
        contentStack.views = [
            chartImageView,
            dateLabel,
            valueLabel
        ]
        contentStack.distribution = .equalSpacing
        contentStack.spacing = 10
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.directionalEdges
                .equalToSuperview()
        }
    }
    
}

//MARK: - Input

extension OverviewChartMarkerContentItem {
    struct Input {
        let date: String
        let value: String
    }
    
}
