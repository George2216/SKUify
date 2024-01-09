//
//  OverviewChartMarkerItem.swift
//  SKUify
//
//  Created by George Churikov on 04.01.2024.
//

import Foundation
import SnapKit

final class OverviewChartMarkerItem: UIView {
    
    //MARK: - UI elements

    private let contentView = OverviewChartMarkerContentItem()
    private lazy var decorateContent = TitleDecorator(decoratedView: contentView)
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        decorateContent.decorate(title: input.chartType.title)
        contentView.setupInput(
            input.contentData,
            chartType: input.chartType
        )
    }
    
    //MARK: - Setup methods

    private func setupContent() {
        addSubview(decorateContent)
        decorateContent.snp.makeConstraints { make in
            make.directionalEdges
                .equalToSuperview()
        }
    }
    
}

//MARK: - Input

extension OverviewChartMarkerItem {
    struct Input {
        let chartType: ChartType
        var isVisible: Bool
        let contentData: OverviewChartMarkerContentItem.Input
    }
    
}
