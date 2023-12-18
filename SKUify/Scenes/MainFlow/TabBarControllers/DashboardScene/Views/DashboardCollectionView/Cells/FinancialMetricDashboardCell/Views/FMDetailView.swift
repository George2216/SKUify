//
//  FMDetailView.swift
//  SKUify
//
//  Created by George Churikov on 05.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class FMDetailView: UIView {
    
    private let percentageArrowImageView = UIImageView()
    private let percentageLabel = UILabel()
    private let last90DaysLabel = UILabel()
    private let last90DaysValueLabel = UILabel()

    // Font for all labels
    private let font: UIFont = .manrope(
        type: .bold,
        size: 10
    )
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviewPercentageArrowImageView()
        addSubviewPercentageLabel()
        addSubviewLast90DaysLabel()
        addSubviewLast90DaysValueLabel()
        
        setupView()
        setuLast90DaysLabel()
        setuLast90DaysValueLabel()
        setupLabelsFonts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInput(_ input: Input) {
        let color: UIColor = input.isUp ?
            .greenTextColor :
            .red
        
        setToPercentageArrowImageView(
            input,
            color: color
        )
        setToPercentageLabel(
            input,
            color: color
        )
        setToLast90DaysLabel()
        setToLast90DaysValueLabel(input)
    }
    
    // MARK: - Set data
    
    private func setToLast90DaysValueLabel(_ input: Input) {
        last90DaysValueLabel.text = input.last90Days
    }
    
    private func setToLast90DaysLabel() {
        last90DaysLabel.text = "Last 90 Days"
    }
    
    private func setToPercentageLabel(
        _ input: Input,
        color: UIColor
    ) {
        percentageLabel.textColor = color
        percentageLabel.text = input.percentage
    }
    
    private func setToPercentageArrowImageView(
        _ input: Input,
        color: UIColor
    ) {
        let image: UIImage? = input.isUp ?
            UIImage(systemName: "arrow.up") :
            UIImage(systemName: "arrow.down")
        
        percentageArrowImageView.image = image?
            .withConfiguration(
                UIImage.SymbolConfiguration(
                    font: font
                )
            )
        percentageArrowImageView.tintColor = color
    }
    
    // MARK: Setup Views
    
    private func setupLabelsFonts() {
        last90DaysValueLabel.font = font
        last90DaysLabel.font = font
        percentageLabel.font = font
    }
    
    private func setuLast90DaysLabel() {
        last90DaysLabel.textColor = .textColor
    }
    
    private func setuLast90DaysValueLabel() {
        last90DaysValueLabel.textColor = .textColor
    }
    
    private func setupView() {
        backgroundColor = .border
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    
    // MARK: - Add to subview
    
    private func addSubviewLast90DaysValueLabel() {
        addSubview(last90DaysValueLabel)
        last90DaysValueLabel.snp.makeConstraints { make in
            make.top
                .equalTo(percentageArrowImageView.snp.bottom)
            make.leading
                .equalTo(last90DaysLabel.snp.trailing)
                .offset(4)
            make.bottom
                .equalToSuperview()
                .inset(4)

        }
    }
    
    private func addSubviewLast90DaysLabel() {
        addSubview(last90DaysLabel)
        last90DaysLabel.snp.makeConstraints { make in
            make.top
                .equalTo(percentageArrowImageView.snp.bottom)
            make.leading
                .equalToSuperview()
                .inset(4)
            make.bottom
                .equalToSuperview()
                .inset(4)
        }
    }
    
    private func addSubviewPercentageLabel() {
        addSubview(percentageLabel)
        percentageLabel.snp.makeConstraints { make in
            make.leading
                .equalTo(percentageArrowImageView.snp.trailing)
                .offset(4)
            make.top
                .equalToSuperview()
                .inset(4)
        }
    }
    
    private func addSubviewPercentageArrowImageView() {
        addSubview(percentageArrowImageView)
        percentageArrowImageView.snp.makeConstraints { make in
            make.top
                .leading
                .equalToSuperview()
                .inset(4)
            make.size
                .equalTo(15)
        }
    }
}

// MARK: - Input

extension FMDetailView {
    struct Input {
        let isUp: Bool
        let percentage: String
        let last90Days: String
    }
}
