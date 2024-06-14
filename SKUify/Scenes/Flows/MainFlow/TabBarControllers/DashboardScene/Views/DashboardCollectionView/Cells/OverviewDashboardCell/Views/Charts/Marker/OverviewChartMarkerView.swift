//
//  OverviewChartMarkerView.swift
//  SKUify
//
//  Created by George Churikov on 04.01.2024.
//

import Foundation
import DGCharts
import Foundation
import UIKit
import SwifterSwift

final class OverviewChartMarkerView: MarkerView {
    
    private let contentStack = VerticalStack()
    
    convenience init(chartView: LineChartView) {
        self.init(frame: .zero)
        self.chartView = chartView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cellColor
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        contentStack.views = input.content.compactMap({ input in
            guard input.isVisible else { return nil }
            let view = OverviewChartMarkerItem()
            view.setupInput(input)
            return view
        })
        contentStack.layoutIfNeeded()
        layoutIfNeeded()
        layoutSubviews()
        setNeedsDisplay()
    }
    
    private func setupContentStack() {
        contentStack.layoutMargins = UIEdgeInsets(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )
        contentStack.isLayoutMarginsRelativeArrangement = true
        
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
    override func layoutIfNeeded() {
        let size = contentStack
            .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        bounds.size = size
        setupRadiusAndShadow()
        offset.y = -self.frame.size.height - 4.0
        
        layer.backgroundColor = UIColor.cellColor.cgColor
        super.layoutIfNeeded()
    }
  
    private func setupRadiusAndShadow() {
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowRadius = 7
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowColor = UIColor.black.cgColor
    }
}

extension OverviewChartMarkerView {
    struct Input {
        var content: [OverviewChartMarkerItem.Input]
    }
    
}
