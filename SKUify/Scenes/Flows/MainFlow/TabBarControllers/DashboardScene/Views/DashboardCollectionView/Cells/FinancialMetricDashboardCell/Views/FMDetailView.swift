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
    private let rangeTitleLabel = UILabel()
    private let rangeValueValue = UILabel()

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
        setToRangeTitleLabel(input)
        setToRangeValueLabel(input)
        setToPercentageArrowImageView(input)
        setToPercentageLabel(input)
    }
    
    // MARK: - Set data
    
    private func setToRangeValueLabel(_ input: Input) {
        rangeValueValue.text = input.rangeVaue
    }
    
    private func setToRangeTitleLabel(_ input: Input) {
        rangeTitleLabel.text = input.rangeTitle
    }
    
    private func setToPercentageLabel(_ input: Input) {
        percentageLabel.textColor = input.percentStatus.color
        percentageLabel.text = input.percentage
    }
    
    private func setToPercentageArrowImageView(_ input: Input) {
        percentageArrowImageView.image = input.percentStatus.image?
            .withConfiguration(
                UIImage.SymbolConfiguration(
                    font: font
                )
            )
        percentageArrowImageView.tintColor = input.percentStatus.color
    }
    
    // MARK: Setup Views
    
    private func setupLabelsFonts() {
        rangeValueValue.font = font
        rangeTitleLabel.font = font
        percentageLabel.font = font
    }
    
    private func setuLast90DaysLabel() {
        rangeTitleLabel.textColor = .textColor
    }
    
    private func setuLast90DaysValueLabel() {
        rangeValueValue.textColor = .textColor
    }
    
    private func setupView() {
        backgroundColor = .background
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    
    // MARK: - Add to subview
    
    private func addSubviewLast90DaysValueLabel() {
        addSubview(rangeValueValue)
        rangeValueValue.snp.makeConstraints { make in
            make.top
                .equalTo(percentageArrowImageView.snp.bottom)
            make.leading
                .equalTo(rangeTitleLabel.snp.trailing)
                .offset(4)
            make.bottom
                .equalToSuperview()
                .inset(4)

        }
    }
    
    private func addSubviewLast90DaysLabel() {
        addSubview(rangeTitleLabel)
        rangeTitleLabel.snp.makeConstraints { make in
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
        let percentStatus: PercentStatus
        let percentage: String
        let rangeTitle: String
        let rangeVaue: String
    }
    
    enum PercentStatus {
        case positive
        case negative
        case unchanged
        
        fileprivate var color: UIColor {
            switch self {
            case .positive:
                return .greenTextColor
            case .negative:
                return .systemRed
            case .unchanged:
                return .refundsChart
            }
        }
        
        
        fileprivate var image: UIImage? {
            switch self {
            case .positive:
                return UIImage(systemName: "arrow.up")
            case .negative:
                return UIImage(systemName: "arrow.down")
            case .unchanged:
                return UIImage(systemName: "minus")
            }
        }
        
    }
    
}
