//
//  TimeSlotCell.swift
//  SKUify
//
//  Created by George Churikov on 20.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class TimeSlotCell: UICollectionViewCell {
    
    // MARK: - Is Selected state

    override var isSelected: Bool {
        didSet {
            colorsByIsSelected()
            guard let row, isSelected else { return }
            selectRow?(row)
        }
    }
    
    // MARK: - Row storage and action of taping on a row

    var row: Int?
    private var selectRow: ((Int) -> Void)?
    
    // MARK: - UIElements
    
    private lazy var titleLabel = UILabel()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupTitleLabel()
        colorsByIsSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup data

    func setInput(_ input: Input) {
        titleLabel.text = input.title
        selectRow = input.selectRow
    }
    
    // MARK: - Setup views

    private func setupCell() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
    
    private func colorsByIsSelected() {
        let textColor: UIColor = !isSelected ? .primaryPurple : .white
        let backgroundColor: UIColor = !isSelected ? .cellColor : .primaryPurple

        self.backgroundColor = backgroundColor
        titleLabel.textColor = textColor
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .bold,
            size: 15
        )
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading
                .equalToSuperview()
                .inset(10)
            make.centerY
                .equalToSuperview()
        }
    }
    
}

// MARK: - Cell input

extension TimeSlotCell {
    struct Input {
        let title: String
        let selectRow: ((Int) -> Void)?
    }
}
